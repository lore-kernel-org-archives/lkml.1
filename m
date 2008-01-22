Return-Path: <linux-kernel-owner+w=401wt.eu-S1753980AbYAVUOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbYAVUOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 15:14:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbYAVUOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 15:14:08 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47524 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751694AbYAVUOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 15:14:07 -0500
Date: Tue, 22 Jan 2008 20:39:15 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, mingo@redhat.com,
       hpa@zytor.com
Subject: Incorrect filename comments in arch/x86/boot
Message-ID: <20080122193915.GA3926@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Not sure if this is worth fixing, or if I should just delete those
comments...? (Or does someone want to do that? ;-). 
									Pavel

pavel@amd:/data/l/linux/arch/x86/boot$ grep arch/i386/boot *.c
a20.c: * arch/i386/boot/a20.c
apm.c: * arch/i386/boot/apm.c
cmdline.c: * arch/i386/boot/cmdline.c
cpu.c: * arch/i386/boot/cpu.c
cpucheck.c: * arch/i386/boot/cpucheck.c
edd.c: * arch/i386/boot/edd.c
main.c: * arch/i386/boot/main.c
mca.c: * arch/i386/boot/mca.c
memory.c: * arch/i386/boot/memory.c
pm.c: * arch/i386/boot/pm.c
printf.c: * arch/i386/boot/printf.c
string.c: * arch/i386/boot/string.c
tty.c: * arch/i386/boot/tty.c
version.c: * arch/i386/boot/version.c
video-vesa.c: * arch/i386/boot/video-vesa.c
video-vga.c: * arch/i386/boot/video-vga.c
voyager.c: * arch/i386/boot/voyager.c
...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
