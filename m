Return-Path: <linux-kernel-owner+w=401wt.eu-S1753272AbXLaUWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbXLaUWb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 15:22:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbXLaUWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 15:22:22 -0500
Received: from mail.atlantis.sk ([80.94.52.35]:50976 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393AbXLaUWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 15:22:21 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
Date: Mon, 31 Dec 2007 21:22:09 +0100
User-Agent: KMail/1.9.7
Cc: Rene Herman <rene.herman@keyaccess.nl>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, hpa@zytor.com,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <477711DC.5030800@keyaccess.nl> <4778FE42.6010003@keyaccess.nl> <20071231155600.0b06552c@the-village.bc.nu>
In-Reply-To: <20071231155600.0b06552c@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712312122.13739.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 31 December 2007 16:56:00 Alan Cox wrote:
> > Okay. Am about to go stuff my face with new years celebrations but will
> > definitely try to make that old WD8003 hickup.
>
> Have fun. Is it an 8390 or an 83905 ?
>

What about HP PCLan 16/TP+ cards? I have one that runs 24/7 in a 486 box 
(2.6.20.6 kernel) and one spare. It has some VLSI HP chip and also ST-NIC 
DP83902AV - is that a good candidate for testing?

I also have WD8013EP with DP8390DV chip - that's probably even better.

-- 
Ondrej Zary
