Return-Path: <linux-kernel-owner+w=401wt.eu-S1756140AbXJCQZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbXJCQZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 12:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbXJCQZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 12:25:39 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:45376 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbXJCQZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 12:25:38 -0400
Date: Wed, 3 Oct 2007 18:25:37 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Alexander Viro <viro@ftp.linux.org.uk>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [bug] crash when reading /proc/mounts (was: Re: Linux 2.6.23-rc9
 and a heads-up for the 2.6.24 series..)
In-Reply-To: <alpine.LFD.0.999.0710030908310.3579@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0710031825250.22106@fbirervta.pbzchgretzou.qr>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org>
 <20071003084607.GC32218@elte.hu> <alpine.LFD.0.999.0710030804310.3579@woody.linux-foundation.org>
 <20071003165128.46e232ab@the-village.bc.nu>
 <alpine.LFD.0.999.0710030908310.3579@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 3 2007 09:09, Linus Torvalds wrote:
>On Wed, 3 Oct 2007, Alan Cox wrote:
>>
>> > and btw, there is no question what-so-ever about whether your compiler 
>> > might be doing a legal optimization - the compiler really is wrong, and is 
>> 
>> Pedant: valid. Almost all optimizations are legal, nobody has yet written
>> laws about compilers. Sorry but I'm forever fixing misuse of the word
>> "illegal" in printks, docs and the like and it gets annoying after a bit.
>
>Heh.
>
>When I'm ruler of the universe, it *will* be illegal. I'm just getting a 
>bit ahead of myself.

Any time frame when that will happen?
