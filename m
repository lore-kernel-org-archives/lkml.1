Return-Path: <linux-kernel-owner+w=401wt.eu-S1759517AbYDZQjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759517AbYDZQjp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 12:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754984AbYDZQjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 12:39:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56601 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753936AbYDZQjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 12:39:36 -0400
Date: Sat, 26 Apr 2008 09:38:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUILDFIX PATCH] v4l/dvb: add statics to avoid multiple
 definitions
In-Reply-To: <20080426100130.GA2252@cs181133002.pp.htv.fi>
Message-ID: <alpine.LFD.1.10.0804260933370.2813@woody.linux-foundation.org>
References: <1209175388.14173.10.camel@brick> <20080426100130.GA2252@cs181133002.pp.htv.fi>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 26 Apr 2008, Adrian Bunk wrote:
>
> I'm wondering what I am doing wrong since I already sent the same patch 
> and it went not into Linus' tree.

Why the hell are you even wondering?

You didn't send the patch to me. It's that damn simple. Harvey did.

I do *not* troll the internet for random patches to apply. But I do apply 
random patches that fix build errors etc, WHEN THEY ARE SENT TO ME.

That said, I'm not asking people to send patches directly to me when there 
is a maintainer that can handle it, but obviously when people do send 
obvious patches that I feel comfy applying and make sense to apply, I'll 
do so.

In other words, don't send cleanup patches to me when there is a 
maintainer, but if there is a build fix or an oops/security fix that you 
want to go into my tree asap, feel free to short-circuit maintainership.

This should be neither new nor surprising to anybody.

			Linus
