Return-Path: <linux-kernel-owner+w=401wt.eu-S1756342AbXL3UBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342AbXL3UBt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 15:01:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753772AbXL3UBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 15:01:40 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54526 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751034AbXL3UBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 15:01:39 -0500
Date: Sun, 30 Dec 2007 12:00:05 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rene Herman <rene.herman@keyaccess.nl>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       dpreed@reed.com, Islam Amer <pharon@gmail.com>, hpa@zytor.com,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
In-Reply-To: <4777F297.9070207@keyaccess.nl>
Message-ID: <alpine.LFD.1.00.0712301158410.32517@woody.linux-foundation.org>
References: <477711DC.5030800@keyaccess.nl> <alpine.LFD.1.00.0712300124440.32517@woody.linux-foundation.org> <20071230144700.78f4605c@the-village.bc.nu> <20071230152835.GX16946@elte.hu> <20071230153818.1a554a7e@the-village.bc.nu> <20071230160132.GA14311@elte.hu>
 <20071230164828.039916c8@the-village.bc.nu> <4777E010.7030703@keyaccess.nl> <20071230183927.5a5a3c42@the-village.bc.nu> <4777F297.9070207@keyaccess.nl>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 30 Dec 2007, Rene Herman wrote:
> 
> I also just now dug up a "WDC (C) 1987" WD8003EBT and a "Novell, Inc (C) 1990"
> NE1000, both 8-bit ISA NICs and the ownership of which, I would suggest, makes
> me a really cool person.

.. I'm also told that mentioning this is a really good way to pick up any 
hot chicks in singles bars.

"If you've got it, flaunt it".

Please let us know how it turns out for you,

			Linus
