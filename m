Return-Path: <linux-kernel-owner+w=401wt.eu-S1755598AbXJCRHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598AbXJCRHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 13:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbXJCRHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 13:07:43 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49078 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752387AbXJCRHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 13:07:43 -0400
Date: Wed, 3 Oct 2007 10:07:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Alexander Viro <viro@ftp.linux.org.uk>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [bug] crash when reading /proc/mounts (was: Re: Linux 2.6.23-rc9
 and a heads-up for the 2.6.24 series..)
In-Reply-To: <Pine.LNX.4.64.0710031825250.22106@fbirervta.pbzchgretzou.qr>
Message-ID: <alpine.LFD.0.999.0710031006250.3579@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org>
 <20071003084607.GC32218@elte.hu> <alpine.LFD.0.999.0710030804310.3579@woody.linux-foundation.org>
 <20071003165128.46e232ab@the-village.bc.nu>
 <alpine.LFD.0.999.0710030908310.3579@woody.linux-foundation.org>
 <Pine.LNX.4.64.0710031825250.22106@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Oct 2007, Jan Engelhardt wrote:
>
> >When I'm ruler of the universe, it *will* be illegal. I'm just getting a 
> >bit ahead of myself.
> 
> Any time frame when that will happen?

I'm working on it, I'm working on it. I'm just as frustrated as you are. 
It turns out to be a non-trivial problem. 

			Linus
