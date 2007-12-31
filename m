Return-Path: <linux-kernel-owner+w=401wt.eu-S1753741AbXLaQGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741AbXLaQGi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 11:06:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751109AbXLaQGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 11:06:30 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51880 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750905AbXLaQGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 11:06:30 -0500
Date: Mon, 31 Dec 2007 15:56:00 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, hpa@zytor.com,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
Message-ID: <20071231155600.0b06552c@the-village.bc.nu>
In-Reply-To: <4778FE42.6010003@keyaccess.nl>
References: <477711DC.5030800@keyaccess.nl>
	<alpine.LFD.1.00.0712300124440.32517@woody.linux-foundation.org>
	<20071230144700.78f4605c@the-village.bc.nu>
	<20071230152835.GX16946@elte.hu>
	<20071230153818.1a554a7e@the-village.bc.nu>
	<20071230160132.GA14311@elte.hu>
	<20071230164828.039916c8@the-village.bc.nu>
	<4777E010.7030703@keyaccess.nl>
	<20071231122344.7b403cd8@the-village.bc.nu>
	<4778FE42.6010003@keyaccess.nl>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Okay. Am about to go stuff my face with new years celebrations but will 
> definitely try to make that old WD8003 hickup.

Have fun. Is it an 8390 or an 83905 ?

> By the way, expected, but before anyone else mentions it -- no, reading from 
> port 0x61 is not a reliable delay today. Duron 1300 / AMD756:

No big suprise - the comment is from about 1992.

Alan
