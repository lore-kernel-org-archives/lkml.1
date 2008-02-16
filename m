Return-Path: <linux-kernel-owner+w=401wt.eu-S1757846AbYBPQwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757846AbYBPQwQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 11:52:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbYBPQwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 11:52:03 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:36969 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbYBPQwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 11:52:01 -0500
Date: Sat, 16 Feb 2008 17:52:00 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: rusty@rustcorp.com.au
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.25-rc2
In-Reply-To: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0802152258170.30301@fbirervta.pbzchgretzou.qr>
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 15 2008 13:23, Linus Torvalds wrote:
>
>Just to show how _much_ of a winner it is, it's been awarded a coveted 
>"weasel" series name, which should tell you just how good it's going to 
>be. It's a name revered in Linux kernel history, and as such this brings 
>back the good old days where if you find a bug, you're almost certainly 
>simply mistaken, and you probably just did something wrong.

1. Release Linux Kernel
2. Give it a weasel name
3. ??
4. Profit!!

>
>But hey, you can try to prove me wrong.  I dare you.
>
ERROR: "LGUEST_PAGES_guest_gdt_desc" [drivers/lguest/lg.ko] undefined!
ERROR: "LGUEST_PAGES_host_gdt_desc" [drivers/lguest/lg.ko] undefined!
ERROR: "LGUEST_PAGES_host_cr3" [drivers/lguest/lg.ko] undefined!
...

.config see http://pastebin.ca/906358
