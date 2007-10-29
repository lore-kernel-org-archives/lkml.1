Return-Path: <linux-kernel-owner+w=401wt.eu-S1755012AbXJ2AGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012AbXJ2AGa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 20:06:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbXJ2AGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 20:06:23 -0400
Received: from aun.it.uu.se ([130.238.12.36]:40398 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641AbXJ2AGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 20:06:22 -0400
Date: Mon, 29 Oct 2007 01:05:58 +0100 (MET)
Message-Id: <200710290005.l9T05wM5001672@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: linux-kernel@vger.kernel.org
Subject: [REGRESSION] 2.6.24-rc1 fails to boot on a 486
Cc: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

My old 486 fails to boot with the 2.6.24-rc1 kernel.
Grub loads it, 4 lines of text appear but not the kernel's
"Linux version <blah> greet", and the machine reboots.
Double-checked with a serial console: nothing appears
before it reboots.

All 2.6 kernels up to 2.6.23 worked fine on this machine.

Config is at http://user.it.uu.se/~mikpe/linux/tmp/486-config-2.6.24-rc1.
The kernel is unpatched 2.6.24-rc1 compiled with gcc-4.2.2.

/Mikael
