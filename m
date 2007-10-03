Return-Path: <linux-kernel-owner+w=401wt.eu-S1756957AbXJCQJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957AbXJCQJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 12:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbXJCQJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 12:09:34 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48092 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751341AbXJCQJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 12:09:33 -0400
Date: Wed, 3 Oct 2007 09:09:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Alexander Viro <viro@ftp.linux.org.uk>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [bug] crash when reading /proc/mounts (was: Re: Linux 2.6.23-rc9
 and a heads-up for the 2.6.24 series..)
In-Reply-To: <20071003165128.46e232ab@the-village.bc.nu>
Message-ID: <alpine.LFD.0.999.0710030908310.3579@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org>
 <20071003084607.GC32218@elte.hu> <alpine.LFD.0.999.0710030804310.3579@woody.linux-foundation.org>
 <20071003165128.46e232ab@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Oct 2007, Alan Cox wrote:
>
> > and btw, there is no question what-so-ever about whether your compiler 
> > might be doing a legal optimization - the compiler really is wrong, and is 
> 
> Pedant: valid. Almost all optimizations are legal, nobody has yet written
> laws about compilers. Sorry but I'm forever fixing misuse of the word
> "illegal" in printks, docs and the like and it gets annoying after a bit.

Heh.

When I'm ruler of the universe, it *will* be illegal. I'm just getting a 
bit ahead of myself.

			Linus
