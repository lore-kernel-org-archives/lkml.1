Return-Path: <linux-kernel-owner+w=401wt.eu-S932703AbZIELSJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932703AbZIELSJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 07:18:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757327AbZIELSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 07:18:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:51829 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757288AbZIELSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 07:18:06 -0400
Subject: 20 Section mismatch warnings from x86_init,
 arch/x86/kernel/x86_init.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 05 Sep 2009 16:44:30 +0530
Message-Id: <1252149270.4969.6.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: arch/x86/kernel/built-in.o(.data+0x1c8): Section mismatch in reference from the variable x86_init to the function .cpuinit.text:x86_init_noop()
The variable x86_init references
the function __cpuinit x86_init_noop()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: arch/x86/kernel/built-in.o(.data+0x1cc): Section mismatch in reference from the variable x86_init to the function .init.text:reserve_standard_io_resources()
The variable x86_init references
the function __init reserve_standard_io_resources()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: arch/x86/kernel/built-in.o(.data+0x1d0): Section mismatch in reference from the variable x86_init to the function .init.text:default_machine_specific_memory_setup()
The variable x86_init references
the function __init default_machine_specific_memory_setup()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: arch/x86/kernel/built-in.o(.data+0x1d4): Section mismatch in reference from the variable x86_init to the function .init.text:x86_init_uint_noop()
The variable x86_init references
the function __init x86_init_uint_noop()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: arch/x86/kernel/built-in.o(.data+0x1d8): Section mismatch in reference from the variable x86_init to the function .cpuinit.text:x86_init_noop()
The variable x86_init references
the function __cpuinit x86_init_noop()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: arch/x86/kernel/built-in.o(.data+0x1dc): Section mismatch in reference from the variable x86_init to the function .init.text:default_mpc_apic_id()
The variable x86_init references
the function __init default_mpc_apic_id()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: arch/x86/kernel/built-in.o(.data+0x1e0): Section mismatch in reference from the variable x86_init to the function .init.text:default_smp_read_mpc_oem()
The variable x86_init references
the function __init default_smp_read_mpc_oem()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: arch/x86/kernel/built-in.o(.data+0x1e8): Section mismatch in reference from the variable x86_init to the function .init.text:default_mpc_oem_bus_info()
The variable x86_init references
the function __init default_mpc_oem_bus_info()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: arch/x86/kernel/built-in.o(.data+0x1ec): Section mismatch in reference from the variable x86_init to the function .init.text:default_find_smp_config()
The variable x86_init references
the function __init default_find_smp_config()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: arch/x86/kernel/built-in.o(.data+0x1f0): Section mismatch in reference from the variable x86_init to the function .init.text:default_get_smp_config()
The variable x86_init references
the function __init default_get_smp_config()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: arch/x86/kernel/built-in.o(.data+0x1f4): Section mismatch in reference from the variable x86_init to the function .init.text:init_ISA_irqs()
The variable x86_init references
the function __init init_ISA_irqs()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: arch/x86/kernel/built-in.o(.data+0x1f8): Section mismatch in reference from the variable x86_init to the function .init.text:native_init_IRQ()
The variable x86_init references
the function __init native_init_IRQ()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: arch/x86/kernel/built-in.o(.data+0x1fc): Section mismatch in reference from the variable x86_init to the function .cpuinit.text:x86_init_noop()
The variable x86_init references
the function __cpuinit x86_init_noop()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: arch/x86/kernel/built-in.o(.data+0x200): Section mismatch in reference from the variable x86_init to the function .cpuinit.text:x86_init_noop()
The variable x86_init references
the function __cpuinit x86_init_noop()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: arch/x86/kernel/built-in.o(.data+0x204): Section mismatch in reference from the variable x86_init to the function .cpuinit.text:x86_init_noop()
The variable x86_init references
the function __cpuinit x86_init_noop()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: arch/x86/kernel/built-in.o(.data+0x210): Section mismatch in reference from the variable x86_init to the function .init.text:setup_boot_APIC_clock()
The variable x86_init references
the function __init setup_boot_APIC_clock()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: arch/x86/kernel/built-in.o(.data+0x214): Section mismatch in reference from the variable x86_init to the function .cpuinit.text:x86_init_noop()
The variable x86_init references
the function __cpuinit x86_init_noop()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: arch/x86/kernel/built-in.o(.data+0x218): Section mismatch in reference from the variable x86_init to the function .init.text:hpet_time_init()
The variable x86_init references
the function __init hpet_time_init()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

  LD      arch/x86/built-in.o
WARNING: arch/x86/built-in.o(.data+0x1c8): Section mismatch in reference from the variable x86_init to the function .cpuinit.text:x86_init_noop()
The variable x86_init references
the function __cpuinit x86_init_noop()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: arch/x86/built-in.o(.data+0x1cc): Section mismatch in reference from the variable x86_init to the function .init.text:reserve_standard_io_resources()
The variable x86_init references
the function __init reserve_standard_io_resources()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: arch/x86/built-in.o(.data+0x1d0): Section mismatch in reference from the variable x86_init to the function .init.text:default_machine_specific_memory_setup()
The variable x86_init references
the function __init default_machine_specific_memory_setup()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: arch/x86/built-in.o(.data+0x1d4): Section mismatch in reference from the variable x86_init to the function .init.text:x86_init_uint_noop()
The variable x86_init references
the function __init x86_init_uint_noop()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: arch/x86/built-in.o(.data+0x1d8): Section mismatch in reference from the variable x86_init to the function .cpuinit.text:x86_init_noop()
The variable x86_init references
the function __cpuinit x86_init_noop()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: arch/x86/built-in.o(.data+0x1dc): Section mismatch in reference from the variable x86_init to the function .init.text:default_mpc_apic_id()
The variable x86_init references
the function __init default_mpc_apic_id()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: arch/x86/built-in.o(.data+0x1e0): Section mismatch in reference from the variable x86_init to the function .init.text:default_smp_read_mpc_oem()
The variable x86_init references
the function __init default_smp_read_mpc_oem()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: arch/x86/built-in.o(.data+0x1e8): Section mismatch in reference from the variable x86_init to the function .init.text:default_mpc_oem_bus_info()
The variable x86_init references
the function __init default_mpc_oem_bus_info()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: arch/x86/built-in.o(.data+0x1ec): Section mismatch in reference from the variable x86_init to the function .init.text:default_find_smp_config()
The variable x86_init references
the function __init default_find_smp_config()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: arch/x86/built-in.o(.data+0x1f0): Section mismatch in reference from the variable x86_init to the function .init.text:default_get_smp_config()
The variable x86_init references
the function __init default_get_smp_config()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: arch/x86/built-in.o(.data+0x1f4): Section mismatch in reference from the variable x86_init to the function .init.text:init_ISA_irqs()
The variable x86_init references
the function __init init_ISA_irqs()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: arch/x86/built-in.o(.data+0x1f8): Section mismatch in reference from the variable x86_init to the function .init.text:native_init_IRQ()
The variable x86_init references
the function __init native_init_IRQ()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: arch/x86/built-in.o(.data+0x1fc): Section mismatch in reference from the variable x86_init to the function .cpuinit.text:x86_init_noop()
The variable x86_init references
the function __cpuinit x86_init_noop()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: arch/x86/built-in.o(.data+0x200): Section mismatch in reference from the variable x86_init to the function .cpuinit.text:x86_init_noop()
The variable x86_init references
the function __cpuinit x86_init_noop()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: arch/x86/built-in.o(.data+0x204): Section mismatch in reference from the variable x86_init to the function .cpuinit.text:x86_init_noop()
The variable x86_init references
the function __cpuinit x86_init_noop()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: arch/x86/built-in.o(.data+0x208): Section mismatch in reference from the variable x86_init to the function .init.text:native_pagetable_setup_start()
The variable x86_init references
the function __init native_pagetable_setup_start()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: arch/x86/built-in.o(.data+0x20c): Section mismatch in reference from the variable x86_init to the function .init.text:native_pagetable_setup_done()
The variable x86_init references
the function __init native_pagetable_setup_done()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: arch/x86/built-in.o(.data+0x210): Section mismatch in reference from the variable x86_init to the function .init.text:setup_boot_APIC_clock()
The variable x86_init references
the function __init setup_boot_APIC_clock()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: arch/x86/built-in.o(.data+0x214): Section mismatch in reference from the variable x86_init to the function .cpuinit.text:x86_init_noop()
The variable x86_init references
the function __cpuinit x86_init_noop()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: arch/x86/built-in.o(.data+0x218): Section mismatch in reference from the variable x86_init to the function .init.text:hpet_time_init()
The variable x86_init references
the function __init hpet_time_init()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 


