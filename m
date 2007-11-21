Return-Path: <linux-kernel-owner+w=401wt.eu-S1753550AbXKUVZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbXKUVZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 16:25:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751875AbXKUVZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 16:25:10 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:54407 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbXKUVZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 16:25:09 -0500
Date: Wed, 21 Nov 2007 22:25:07 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Bron Gondwana <brong@fastmail.fm>,
       Christian Kujau <lists@nerdbynature.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       robm@fastmail.fm
Subject: Re: mmap dirty limits on 32 bit kernels (Was: [BUG] New Kernel Bugs)
In-Reply-To: <alpine.LFD.0.9999.0711151342100.4260@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0711212212580.14695@fbirervta.pbzchgretzou.qr>
References: <alpine.LFD.0.9999.0711151342100.4260@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 15 Nov 2007 13:47:54 -0800 (PST) Linus Torvalds wrote:
>
>But quite frankly, I refuse to even care about anything past that. If 
>you have 12G (or heaven forbid, even more) in your machine, and you 
>can't be bothered to just upgrade to a 64-bit CPU, then quite frankly, 
>*I* personally can't be bothered to care.
>
>If they have that much RAM (and bought it a few years ago when a 64-bit 
>CPU wasn't an option), they can't be poor.
>
>So the _only_ explanation today for 12GB on a 32-bit machine is
> (a) insanity
>or 
> (b) being so lazy as to not bother to upgrade
>

Just around the corner...

$ ftp ftp
Connected to ftp.gwdg.de.
220-====================================================================
220-Gesellschaft fuer wissenschaftliche Datenverarbeitung mbH Goettingen
220-====================================================================
220-This is a Linux PC (Dell PE-2650, 2 CPUs P4/2800, 12 GB RAM)
220-running SuSE-Linux-8.2 with SuSE kernel 2.4.20-64GB-SMP.

There is no reason to upgrade the hardware - if it works, hey good then.
And I am pretty sure that a few 2 GB sticks are cheaper than a big 
opteron (if you only go by that). It sure is now - and probably even 
back then.
