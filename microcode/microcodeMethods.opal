new method __nop() {
    if NOP_ALERT {
        new Register tmp = Register(None, RAM_ADDR_SIZE, False);
        tmp.data = this.getProgramCounter().data.copy();
        tmp.dec();

        IO.out("WARNING: CPU executed NOP (address 0x", Compiler.bitArrayToHex(tmp.data, ceil(RAM_ADDR_SIZE / 4)), ").\n");
    }
}

new method __li(toFill) {
    new function li() {
        this.getProgramCounter().write();
        this.mar.load();

        $call clock

        this.ram.write();
        toFill.load();

        this.getProgramCounter().inc();
    }
    
    return li;
}

new method __fl(toFill) {
    new function fl() {
        this.instructionRegister.write();
        toFill.load();
    }
    
    return fl;
}

new method __lo(toFill) {
    new function lo() {
        this.getProgramCounter().write();
        this.mar.load();

        $call clock

        this.ram.write();
        this.mar.load();

        $call clock

        this.ram.write();
        toFill.load();

        this.getProgramCounter().inc();
    }

    return lo;
}

new method __st(toStore) {
    new function st() {
        this.getProgramCounter().write();
        this.mar.load();

        $call clock

        this.ram.write();
        this.mar.load();

        $call clock

        toStore.write();
        this.ram.load();

        this.getProgramCounter().inc();
    }

    return st;
}

new method __add() {
    this.alu.add();
    this.regX.load();
}

new method __sub() {
    this.alu.sub();
    this.regX.load();
}

new method __adsbi() {
    this.getProgramCounter().write();
    this.mar.load();

    $call clock

    this.ram.write();
    this.regA.load();

    this.getProgramCounter().inc();

    $call clock

    this.getProgramCounter().write();
    this.mar.load();

    $call clock

    this.ram.write();
    this.regB.load();

    this.getProgramCounter().inc();

    $call clock
}

new method __adi() {
    this.__adsbi();

    this.alu.add();
    this.regX.load();
}

new method __sbi() {
    this.__adsbi();

    this.alu.sub();
    this.regX.load();
}

new method __dli() {
    this.__li(this.display)();
    this.display.show();
}

new method __fdl() {
    this.__fl(this.display)();
    this.display.show();
}

new method __jmp() {
    this.getProgramCounter().write();
    this.mar.load();

    $call clock

    this.ram.write();
    this.getProgramCounter().load();
}

new method __jmi() {
    this.instructionRegister.write();
    this.getProgramCounter().load();
}

new method __condJump(idx, fn) {
    new function condJump() {
        if this.flags.data[idx] {
            fn();
        } elif fn == this.__jmp {
            this.getProgramCounter().inc();
        }
    }
    
    return condJump;
}

new method __shiftRotate(toCall) {
    new function sr() {
        repeat this.instructionRegister.low.toDec() {
            toCall();
        }
    }

    return sr;
}

new method __mov(toWrite, toFill) {
    new function mov() {
        toWrite.write();
        toFill.load();
    }

    return mov;
}

new method __la(register) {
    new function la() {
        register.write();
        this.mar.load();

        $call clock

        this.ram.write();
        register.load();
    }

    return la;
}

new method __cpi() {
    this.__adsbi();
    this.alu.sub();
}

new method __ps(toPush) {
    new function ps() {
        this.sp.inc();

        $call clock

        this.sp.write();
        this.mar.load();

        $call clock

        toPush.write();
        this.ram.load();
    }

    return ps;
}

new method __pp(toPop) {
    new function pp() {
        this.sp.write();
        this.mar.load();

        $call clock

        this.ram.write();
        toPop.load();
        this.sp.dec();
    }

    return pp;
}

new method __jsr() {
    this.getProgramCounter().inc();
    this.__ps(this.getProgramCounter())();

    $call clock

    this.getProgramCounter().dec();
    this.__ps(this.regX)();
    $call clock

    this.__ps(this.regY)();
    $call clock

    this.__ps(this.regZ)();
    $call clock

    this.__ps(this.regA)();
    $call clock

    this.__ps(this.regB)();
    $call clock

    this.__ps(this.display)();
    $call clock

    this.__jmp();
}

new method __rts() {
    this.__pp(this.display)();
    $call clock

    this.__pp(this.regB)();
    $call clock

    this.__pp(this.regA)();
    $call clock

    this.__pp(this.regZ)();
    $call clock

    this.__pp(this.regY)();
    $call clock

    this.__pp(this.regX)();
    $call clock

    this.__pp(this.getProgramCounter())();
}

new method __rti() {
    this.__pp(this.getProgramCounter())();

    this.__onInterrupt = False;
    this.interruptRegister.reset();
}

new method __fs(toWrite) {
    new function fs() {
        toWrite.write();
        this.gpu.load();
    }
    
    return fs;
}

new method __addrStore(fromAddress, toWrite) {
    new function addrStore() {
        fromAddress.write();
        this.mar.load();

        $call clock

        toWrite.write();
        this.ram.load();
    }

    return addrStore;
}

new method __snd() {
    this.getProgramCounter().write();
    this.mar.load();

    $call clock

    this.ram.write();
    this.soundChip.load();

    $call clock

    this.getProgramCounter().inc();
    this.soundChip.play();
}

new method __sn(from_) {
    new function sn() {
        from_.write();
        this.soundChip.load();

        $call clock

        this.soundChip.play();
    }

    return sn;
}

new method __wt(toWait) {
    new function wt() {
        new dynamic amt = toWait.toDec();

        if amt == 0 {
            return;
        }

        if this.waitAddress is None or this.waiting or ALWAYS_NOP_WAIT {
            sleep(amt / 1000);
        } else {
            this.waiting = True;

            new dynamic t    = amt / 1000,
                        base = this.waitAddress;

            new dynamic swTime = default_timer();
            this.__memSwap(   this.regA, base + 1);
            this.__memSwap(   this.regB, base + 2);
            this.__memSwap(   this.regX, base + 3);
            this.__memSwap(   this.regY, base + 4);
            this.__memSwap(   this.regZ, base + 5);
            this.__memSwap(this.display, base + 6);

            t -= (default_timer() - swTime) * 2;
            
            while t > 0 {
                new dynamic st = default_timer();

                this.bus.load(Compiler.decimalToBitarray(this.waitAddress));
                this.mar.load();

                $call clock

                this.ram.write();
                this.swap.load();

                $call clock

                this.swap.write();
                this.mar.load();

                $call clock

                this.ram.write();
                this.instructionRegister.load();

                $call clock

                this.bus.load(Compiler.decimalToBitarray(this.waitAddress));
                this.mar.load();

                $call clock

                this.ram.write();
                this.swap.load();

                $call clock

                this.swap.inc();

                $call clock

                this.swap.write();
                this.ram.load();

                this.__handleInstruction();

                t -= default_timer() - st;

                if this.waitEnd is not None {
                    if this.ram.memory[base].toDec() >= this.waitEnd {
                        this.waitAddress = None;
                        sleep(t);
                        break;
                    }
                }
            }

            this.__memSwap(   this.regA, base + 1);
            this.__memSwap(   this.regB, base + 2);
            this.__memSwap(   this.regX, base + 3);
            this.__memSwap(   this.regY, base + 4);
            this.__memSwap(   this.regZ, base + 5);
            this.__memSwap(this.display, base + 6);

            this.waiting = False;
        }
    }

    return wt;
}

new method __fls() {
    this.instructionRegister.write();
    this.mar.loadMBSR();
}

new method __movS(toWrite) {
    new function mov() {
        toWrite.write();
        this.mar.loadMBSR();
    }

    return mov;
}