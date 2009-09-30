Return-Path: <linux-kernel-owner+w=401wt.eu-S1755271AbZI3UIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbZI3UIE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 16:08:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755186AbZI3UIC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 16:08:02 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36490 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149AbZI3UIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 16:08:00 -0400
Date: Wed, 30 Sep 2009 22:07:46 +0200
From: Pavel Machek <pavel@ucw.cz>
To: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz
Cc: linux-input@vger.kernel.org
Subject: 32-rc1 aka 32-rc2: warning at manage.c:361 (set_irq_wake),
	matrix-keypad related?
Message-ID: <20090930200746.GA1384@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

It complains about unbalanced irq 113 wake disable. That one belongs
to matrix-keypad...
								Pavel

spend
leds spitz:green:hddactivity: legacy class suspend
leds spitz:amber:charge: legacy class suspend
input input1: type suspend
input input0: type suspend
mtd mtd2ro: legacy class suspend
mtd mtd2: legacy class suspend
mtd mtd1ro: legacy class suspend
mtd mtd1: legacy class suspend
mtd mtd0ro: legacy class suspend
mtd mtd0: legacy class suspend
serial8250 serial8250: suspend
backlight corgi_bl: legacy class suspend
sharpsl-pm sharpsl-pm: suspend
pxa2xx-pcmcia pxa2xx-pcmcia: suspend
platform regulatory.0: suspend
i2c i2c-0: legacy suspend
max1111 spi2.2: legacy suspend
corgi-lcd spi2.1: legacy suspend
ads7846 spi2.0: legacy suspend
sharp-scoop sharp-scoop.1: suspend
pxa2xx-i2c pxa2xx-i2c.0: suspend
pxa2xx-fb pxa2xx-fb: suspend
platform pxa2xx-ir: suspend
platform pxa27x-ohci: suspend
pxa2xx-mci pxa2xx-mci.0: suspend
platform physmap-flash: suspend
sharpsl-nand sharpsl-nand: suspend
leds-gpio leds-gpio: suspend
matrix-keypad matrix-keypad: suspend, may wakeup
sharp-scoop sharp-scoop.0: suspend
pxa2xx-spi pxa2xx-spi.2: suspend
platform pxa27x-pwm.1: suspend
platform pxa27x-pwm.0: suspend
pxa27x-ssp pxa27x-ssp.2: suspend
pxa27x-ssp pxa27x-ssp.1: suspend
pxa27x-ssp pxa27x-ssp.0: suspend
platform pxa-rtc: suspend
platform sa1100-rtc: suspend
platform pxa2xx-i2s: suspend
platform pxa2xx-uart.2: suspend
platform pxa2xx-uart.1: suspend
platform pxa2xx-uart.0: suspend
platform pxa27x-udc: suspend
serial8250 serial8250: LATE suspend
sharpsl-pm sharpsl-pm: LATE suspend
pxa2xx-pcmcia pxa2xx-pcmcia: LATE suspend
platform regulatory.0: LATE suspend
sharp-scoop sharp-scoop.1: LATE suspend
pxa2xx-i2c pxa2xx-i2c.0: LATE suspend
pxa2xx-fb pxa2xx-fb: LATE suspend
platform pxa2xx-ir: LATE suspend
platform pxa27x-ohci: LATE suspend
pxa2xx-mci pxa2xx-mci.0: LATE suspend
platform physmap-flash: LATE suspend
sharpsl-nand sharpsl-nand: LATE suspend
leds-gpio leds-gpio: LATE suspend
matrix-keypad matrix-keypad: LATE suspend, may wakeup
sharp-scoop sharp-scoop.0: LATE suspend
pxa2xx-spi pxa2xx-spi.2: LATE suspend
platform pxa27x-pwm.1: LATE suspend
platform pxa27x-pwm.0: LATE suspend
pxa27x-ssp pxa27x-ssp.2: LATE suspend
pxa27x-ssp pxa27x-ssp.1: LATE suspend
pxa27x-ssp pxa27x-ssp.0: LATE suspend
platform pxa-rtc: LATE suspend
platform sa1100-rtc: LATE suspend
platform pxa2xx-i2s: LATE suspend
platform pxa2xx-uart.2: LATE suspend
platform pxa2xx-uart.1: LATE suspend
platform pxa2xx-uart.0: LATE suspend
platform pxa27x-udc: LATE suspend
suspend debug: Waiting for 5 seconds.
platform pxa27x-udc: EARLY resume
platform pxa2xx-uart.0: EARLY resume
platform pxa2xx-uart.1: EARLY resume
platform pxa2xx-uart.2: EARLY resume
platform pxa2xx-i2s: EARLY resume
platform sa1100-rtc: EARLY resume
platform pxa-rtc: EARLY resume
pxa27x-ssp pxa27x-ssp.0: EARLY resume
pxa27x-ssp pxa27x-ssp.1: EARLY resume
pxa27x-ssp pxa27x-ssp.2: EARLY resume
platform pxa27x-pwm.0: EARLY resume
platform pxa27x-pwm.1: EARLY resume
pxa2xx-spi pxa2xx-spi.2: EARLY resume
sharp-scoop sharp-scoop.0: EARLY resume
matrix-keypad matrix-keypad: EARLY resume
leds-gpio leds-gpio: EARLY resume
sharpsl-nand sharpsl-nand: EARLY resume
platform physmap-flash: EARLY resume
pxa2xx-mci pxa2xx-mci.0: EARLY resume
platform pxa27x-ohci: EARLY resume
platform pxa2xx-ir: EARLY resume
pxa2xx-fb pxa2xx-fb: EARLY resume
pxa2xx-i2c pxa2xx-i2c.0: EARLY resume
sharp-scoop sharp-scoop.1: EARLY resume
platform regulatory.0: EARLY resume
pxa2xx-pcmcia pxa2xx-pcmcia: EARLY resume
sharpsl-pm sharpsl-pm: EARLY resume
serial8250 serial8250: EARLY resume
platform pxa27x-udc: resume
platform pxa2xx-uart.0: resume
platform pxa2xx-uart.1: resume
platform pxa2xx-uart.2: resume
platform pxa2xx-i2s: resume
platform sa1100-rtc: resume
platform pxa-rtc: resume
pxa27x-ssp pxa27x-ssp.0: resume
pxa27x-ssp pxa27x-ssp.1: resume
pxa27x-ssp pxa27x-ssp.2: resume
platform pxa27x-pwm.0: resume
platform pxa27x-pwm.1: resume
pxa2xx-spi pxa2xx-spi.2: resume
sharp-scoop sharp-scoop.0: resume
matrix-keypad matrix-keypad: resume
------------[ cut here ]------------
WARNING: at kernel/irq/manage.c:361 set_irq_wake+0x7c/0x138()
Unbalanced IRQ 113 wake disable
Modules linked in:
[<c00248f8>] (unwind_backtrace+0x0/0xe4) from [<c003520c>] (warn_slowpath_common+0x4c/0x80)
[<c003520c>] (warn_slowpath_common+0x4c/0x80) from [<c003527c>] (warn_slowpath_fmt+0x28/0x38)
[<c003527c>] (warn_slowpath_fmt+0x28/0x38) from [<c0060b88>] (set_irq_wake+0x7c/0x138)
[<c0060b88>] (set_irq_wake+0x7c/0x138) from [<c01d0484>] (matrix_keypad_resume+0x6c/0x8c)
[<c01d0484>] (matrix_keypad_resume+0x6c/0x8c) from [<c0190d3c>] (platform_pm_resume+0x30/0x54)
[<c0190d3c>] (platform_pm_resume+0x30/0x54) from [<c019302c>] (pm_op+0x6c/0x8c)
[<c019302c>] (pm_op+0x6c/0x8c) from [<c0193af4>] (dpm_resume_end+0xf0/0x47c)
[<c0193af4>] (dpm_resume_end+0xf0/0x47c) from [<c005d980>] (suspend_devices_and_enter+0x8c/0x1dc)
[<c005d980>] (suspend_devices_and_enter+0x8c/0x1dc) from [<c005dbb8>] (enter_state+0xe8/0x120)
[<c005dbb8>] (enter_state+0xe8/0x120) from [<c005d2bc>] (state_store+0x90/0xc4)
[<c005d2bc>] (state_store+0x90/0xc4) from [<c01459bc>] (kobj_attr_store+0x1c/0x24)
[<c01459bc>] (kobj_attr_store+0x1c/0x24) from [<c00d80d8>] (sysfs_write_file+0x104/0x18c)
[<c00d80d8>] (sysfs_write_file+0x104/0x18c) from [<c008ffe8>] (vfs_write+0xb0/0x164)
[<c008ffe8>] (vfs_write+0xb0/0x164) from [<c009016c>] (sys_write+0x40/0x70)
[<c009016c>] (sys_write+0x40/0x70) from [<c001fec0>] (ret_fast_syscall+0x0/0x28)
---[ end trace e1f70a99626339f7 ]---
------------[ cut here ]------------
WARNING: at kernel/irq/manage.c:361 set_irq_wake+0x7c/0x138()
Unbalanced IRQ 187 wake disable
Modules linked in:
[<c00248f8>] (unwind_backtrace+0x0/0xe4) from [<c003520c>] (warn_slowpath_common+0x4c/0x80)
[<c003520c>] (warn_slowpath_common+0x4c/0x80) from [<c003527c>] (warn_slowpath_fmt+0x28/0x38)
[<c003527c>] (warn_slowpath_fmt+0x28/0x38) from [<c0060b88>] (set_irq_wake+0x7c/0x138)
[<c0060b88>] (set_irq_wake+0x7c/0x138) from [<c01d0484>] (matrix_keypad_resume+0x6c/0x8c)
[<c01d0484>] (matrix_keypad_resume+0x6c/0x8c) from [<c0190d3c>] (platform_pm_resume+0x30/0x54)
[<c0190d3c>] (platform_pm_resume+0x30/0x54) from [<c019302c>] (pm_op+0x6c/0x8c)
[<c019302c>] (pm_op+0x6c/0x8c) from [<c0193af4>] (dpm_resume_end+0xf0/0x47c)
[<c0193af4>] (dpm_resume_end+0xf0/0x47c) from [<c005d980>] (suspend_devices_and_enter+0x8c/0x1dc)
[<c005d980>] (suspend_devices_and_enter+0x8c/0x1dc) from [<c005dbb8>] (enter_state+0xe8/0x120)
[<c005dbb8>] (enter_state+0xe8/0x120) from [<c005d2bc>] (state_store+0x90/0xc4)
[<c005d2bc>] (state_store+0x90/0xc4) from [<c01459bc>] (kobj_attr_store+0x1c/0x24)
[<c01459bc>] (kobj_attr_store+0x1c/0x24) from [<c00d80d8>] (sysfs_write_file+0x104/0x18c)
[<c00d80d8>] (sysfs_write_file+0x104/0x18c) from [<c008ffe8>] (vfs_write+0xb0/0x164)
[<c008ffe8>] (vfs_write+0xb0/0x164) from [<c009016c>] (sys_write+0x40/0x70)
[<c009016c>] (sys_write+0x40/0x70) from [<c001fec0>] (ret_fast_syscall+0x0/0x28)
---[ end trace e1f70a99626339f8 ]---
------------[ cut here ]------------
WARNING: at kernel/irq/manage.c:361 set_irq_wake+0x7c/0x138()
Unbalanced IRQ 130 wake disable
Modules linked in:
[<c00248f8>] (unwind_backtrace+0x0/0xe4) from [<c003520c>] (warn_slowpath_common+0x4c/0x80)
[<c003520c>] (warn_slowpath_common+0x4c/0x80) from [<c003527c>] (warn_slowpath_fmt+0x28/0x38)
[<c003527c>] (warn_slowpath_fmt+0x28/0x38) from [<c0060b88>] (set_irq_wake+0x7c/0x138)
[<c0060b88>] (set_irq_wake+0x7c/0x138) from [<c01d0484>] (matrix_keypad_resume+0x6c/0x8c)
[<c01d0484>] (matrix_keypad_resume+0x6c/0x8c) from [<c0190d3c>] (platform_pm_resume+0x30/0x54)
[<c0190d3c>] (platform_pm_resume+0x30/0x54) from [<c019302c>] (pm_op+0x6c/0x8c)
[<c019302c>] (pm_op+0x6c/0x8c) from [<c0193af4>] (dpm_resume_end+0xf0/0x47c)
[<c0193af4>] (dpm_resume_end+0xf0/0x47c) from [<c005d980>] (suspend_devices_and_enter+0x8c/0x1dc)
[<c005d980>] (suspend_devices_and_enter+0x8c/0x1dc) from [<c005dbb8>] (enter_state+0xe8/0x120)
[<c005dbb8>] (enter_state+0xe8/0x120) from [<c005d2bc>] (state_store+0x90/0xc4)
[<c005d2bc>] (state_store+0x90/0xc4) from [<c01459bc>] (kobj_attr_store+0x1c/0x24)
[<c01459bc>] (kobj_attr_store+0x1c/0x24) from [<c00d80d8>] (sysfs_write_file+0x104/0x18c)
[<c00d80d8>] (sysfs_write_file+0x104/0x18c) from [<c008ffe8>] (vfs_write+0xb0/0x164)
[<c008ffe8>] (vfs_write+0xb0/0x164) from [<c009016c>] (sys_write+0x40/0x70)
[<c009016c>] (sys_write+0x40/0x70) from [<c001fec0>] (ret_fast_syscall+0x0/0x28)
---[ end trace e1f70a99626339f9 ]---
------------[ cut here ]------------
WARNING: at kernel/irq/manage.c:361 set_irq_wake+0x7c/0x138()
Unbalanced IRQ 132 wake disable
Modules linked in:
[<c00248f8>] (unwind_backtrace+0x0/0xe4) from [<c003520c>] (warn_slowpath_common+0x4c/0x80)
[<c003520c>] (warn_slowpath_common+0x4c/0x80) from [<c003527c>] (warn_slowpath_fmt+0x28/0x38)
[<c003527c>] (warn_slowpath_fmt+0x28/0x38) from [<c0060b88>] (set_irq_wake+0x7c/0x138)
[<c0060b88>] (set_irq_wake+0x7c/0x138) from [<c01d0484>] (matrix_keypad_resume+0x6c/0x8c)
[<c01d0484>] (matrix_keypad_resume+0x6c/0x8c) from [<c0190d3c>] (platform_pm_resume+0x30/0x54)
[<c0190d3c>] (platform_pm_resume+0x30/0x54) from [<c019302c>] (pm_op+0x6c/0x8c)
[<c019302c>] (pm_op+0x6c/0x8c) from [<c0193af4>] (dpm_resume_end+0xf0/0x47c)
[<c0193af4>] (dpm_resume_end+0xf0/0x47c) from [<c005d980>] (suspend_devices_and_enter+0x8c/0x1dc)
[<c005d980>] (suspend_devices_and_enter+0x8c/0x1dc) from [<c005dbb8>] (enter_state+0xe8/0x120)
[<c005dbb8>] (enter_state+0xe8/0x120) from [<c005d2bc>] (state_store+0x90/0xc4)
[<c005d2bc>] (state_store+0x90/0xc4) from [<c01459bc>] (kobj_attr_store+0x1c/0x24)
[<c01459bc>] (kobj_attr_store+0x1c/0x24) from [<c00d80d8>] (sysfs_write_file+0x104/0x18c)
[<c00d80d8>] (sysfs_write_file+0x104/0x18c) from [<c008ffe8>] (vfs_write+0xb0/0x164)
[<c008ffe8>] (vfs_write+0xb0/0x164) from [<c009016c>] (sys_write+0x40/0x70)
[<c009016c>] (sys_write+0x40/0x70) from [<c001fec0>] (ret_fast_syscall+0x0/0x28)
---[ end trace e1f70a99626339fa ]---
------------[ cut here ]------------
WARNING: at kernel/irq/manage.c:361 set_irq_wake+0x7c/0x138()
Unbalanced IRQ 134 wake disable
Modules linked in:
[<c00248f8>] (unwind_backtrace+0x0/0xe4) from [<c003520c>] (warn_slowpath_common+0x4c/0x80)
[<c003520c>] (warn_slowpath_common+0x4c/0x80) from [<c003527c>] (warn_slowpath_fmt+0x28/0x38)
[<c003527c>] (warn_slowpath_fmt+0x28/0x38) from [<c0060b88>] (set_irq_wake+0x7c/0x138)
[<c0060b88>] (set_irq_wake+0x7c/0x138) from [<c01d0484>] (matrix_keypad_resume+0x6c/0x8c)
[<c01d0484>] (matrix_keypad_resume+0x6c/0x8c) from [<c0190d3c>] (platform_pm_resume+0x30/0x54)
[<c0190d3c>] (platform_pm_resume+0x30/0x54) from [<c019302c>] (pm_op+0x6c/0x8c)
[<c019302c>] (pm_op+0x6c/0x8c) from [<c0193af4>] (dpm_resume_end+0xf0/0x47c)
[<c0193af4>] (dpm_resume_end+0xf0/0x47c) from [<c005d980>] (suspend_devices_and_enter+0x8c/0x1dc)
[<c005d980>] (suspend_devices_and_enter+0x8c/0x1dc) from [<c005dbb8>] (enter_state+0xe8/0x120)
[<c005dbb8>] (enter_state+0xe8/0x120) from [<c005d2bc>] (state_store+0x90/0xc4)
[<c005d2bc>] (state_store+0x90/0xc4) from [<c01459bc>] (kobj_attr_store+0x1c/0x24)
[<c01459bc>] (kobj_attr_store+0x1c/0x24) from [<c00d80d8>] (sysfs_write_file+0x104/0x18c)
[<c00d80d8>] (sysfs_write_file+0x104/0x18c) from [<c008ffe8>] (vfs_write+0xb0/0x164)
[<c008ffe8>] (vfs_write+0xb0/0x164) from [<c009016c>] (sys_write+0x40/0x70)
[<c009016c>] (sys_write+0x40/0x70) from [<c001fec0>] (ret_fast_syscall+0x0/0x28)
---[ end trace e1f70a99626339fb ]---
------------[ cut here ]------------
WARNING: at kernel/irq/manage.c:361 set_irq_wake+0x7c/0x138()
Unbalanced IRQ 135 wake disable
Modules linked in:
[<c00248f8>] (unwind_backtrace+0x0/0xe4) from [<c003520c>] (warn_slowpath_common+0x4c/0x80)
[<c003520c>] (warn_slowpath_common+0x4c/0x80) from [<c003527c>] (warn_slowpath_fmt+0x28/0x38)
[<c003527c>] (warn_slowpath_fmt+0x28/0x38) from [<c0060b88>] (set_irq_wake+0x7c/0x138)
[<c0060b88>] (set_irq_wake+0x7c/0x138) from [<c01d0484>] (matrix_keypad_resume+0x6c/0x8c)
[<c01d0484>] (matrix_keypad_resume+0x6c/0x8c) from [<c0190d3c>] (platform_pm_resume+0x30/0x54)
[<c0190d3c>] (platform_pm_resume+0x30/0x54) from [<c019302c>] (pm_op+0x6c/0x8c)
[<c019302c>] (pm_op+0x6c/0x8c) from [<c0193af4>] (dpm_resume_end+0xf0/0x47c)
[<c0193af4>] (dpm_resume_end+0xf0/0x47c) from [<c005d980>] (suspend_devices_and_enter+0x8c/0x1dc)
[<c005d980>] (suspend_devices_and_enter+0x8c/0x1dc) from [<c005dbb8>] (enter_state+0xe8/0x120)
[<c005dbb8>] (enter_state+0xe8/0x120) from [<c005d2bc>] (state_store+0x90/0xc4)
[<c005d2bc>] (state_store+0x90/0xc4) from [<c01459bc>] (kobj_attr_store+0x1c/0x24)
[<c01459bc>] (kobj_attr_store+0x1c/0x24) from [<c00d80d8>] (sysfs_write_file+0x104/0x18c)
[<c00d80d8>] (sysfs_write_file+0x104/0x18c) from [<c008ffe8>] (vfs_write+0xb0/0x164)
[<c008ffe8>] (vfs_write+0xb0/0x164) from [<c009016c>] (sys_write+0x40/0x70)
[<c009016c>] (sys_write+0x40/0x70) from [<c001fec0>] (ret_fast_syscall+0x0/0x28)
---[ end trace e1f70a99626339fc ]---
leds-gpio leds-gpio: resume
sharpsl-nand sharpsl-nand: resume
platform physmap-flash: resume
pxa2xx-mci pxa2xx-mci.0: resume
platform pxa27x-ohci: resume
platform pxa2xx-ir: resume
pxa2xx-fb pxa2xx-fb: resume
pxa2xx-i2c pxa2xx-i2c.0: resume
sharp-scoop sharp-scoop.1: resume
ads7846 spi2.0: legacy resume
corgi-lcd spi2.1: legacy resume
max1111 spi2.2: legacy resume
i2c i2c-0: legacy resume
platform regulatory.0: resume
pxa2xx-pcmcia pxa2xx-pcmcia: resume
sharpsl-pm sharpsl-pm: resume
backlight corgi_bl: legacy class resume
serial8250 serial8250: resume
mtd mtd0: legacy class resume
mtd mtd0ro: legacy class resume
mtd mtd1: legacy class resume
mtd mtd1ro: legacy class resume
mtd mtd2: legacy class resume
mtd mtd2ro: legacy class resume
input input0: type resume
input input1: type resume
leds spitz:amber:charge: legacy class resume
leds spitz:green:hddactivity: legacy class resume
ide-cs 1.0: legacy resume
ide-gd 0.0: legacy resume
serial8250 serial8250: completing resume
sharpsl-pm sharpsl-pm: completing resume
pxa2xx-pcmcia pxa2xx-pcmcia: completing resume
platform regulatory.0: completing resume
sharp-scoop sharp-scoop.1: completing resume
pxa2xx-i2c pxa2xx-i2c.0: completing resume
pxa2xx-fb pxa2xx-fb: completing resume
platform pxa2xx-ir: completing resume
platform pxa27x-ohci: completing resume
pxa2xx-mci pxa2xx-mci.0: completing resume
platform physmap-flash: completing resume
sharpsl-nand sharpsl-nand: completing resume
leds-gpio leds-gpio: completing resume
matrix-keypad matrix-keypad: completing resume
sharp-scoop sharp-scoop.0: completing resume
pxa2xx-spi pxa2xx-spi.2: completing resume
platform pxa27x-pwm.1: completing resume
platform pxa27x-pwm.0: completing resume
pxa27x-ssp pxa27x-ssp.2: completing resume
pxa27x-ssp pxa27x-ssp.1: completing resume
pxa27x-ssp pxa27x-ssp.0: completing resume
platform pxa-rtc: completing resume
platform sa1100-rtc: completing resume
platform pxa2xx-i2s: completing resume
platform pxa2xx-uart.2: completing resume
platform pxa2xx-uart.1: completing resume
platform pxa2xx-uart.0: completing resume
platform pxa27x-udc: completing resume
PM: Finishing wakeup.
Restarting tasks ... done.
hda: status error: status=0x59 { DriveReady SeekComplete DataRequest Error }
hda: status error: error=0x04 { DriveStatusError }
hda: possibly failed opcode: 0xc5
hda: no DRQ after issuing MULTWRITE
ide0: reset: success
sharpsl-pm sharpsl-pm: Error: AC check failed.
sharpsl-pm sharpsl-pm: Charging Error!
sharpsl-pm sharpsl-pm: Error: AC check failed.
sharpsl-pm sharpsl-pm: Charging Error!


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
