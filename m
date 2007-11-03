Return-Path: <linux-kernel-owner+w=401wt.eu-S1755185AbXKCMwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185AbXKCMwW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 08:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbXKCMwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 08:52:15 -0400
Received: from mail.acc.umu.se ([130.239.18.156]:46590 "EHLO mail.acc.umu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539AbXKCMwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 08:52:14 -0400
X-Greylist: delayed 1216 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Nov 2007 08:52:14 EDT
Date: Sat, 3 Nov 2007 13:31:49 +0100 (CET)
From: =?ISO-8859-1?Q?Bo_Brant=E9n?= <bosse@acc.umu.se>
To: linux-kernel@vger.kernel.org
Subject: x86_64 ten times slower than i386
Message-ID: <Pine.A41.4.64.0711031329490.397338@stalin.acc.umu.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

I tryed different linux distributions on a computer with an Intel Core 2 Quad 
and I noticed that the 64-bit versions was at least 10 times slower than the 
32-bit versions, to boot the system took over 20 minutes in 64-bit mode and 
then even scrolling text at the command prompt felt slow, however Vista 64 
boots as fast as Vista 32 on the same computer. So I would like to ask if this 
is a known problem or if there is some simple misstake I can have done.

I used live cd's from gentoo and ubunto and at least ubuntu has a rather new 
kernel, also dmesg doesn't show anything strange, for example is the bogomips 
figure the same as when booting in 32-bit mode.
