Return-Path: <linux-kernel-owner+w=401wt.eu-S1754216Ab0ARPxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab0ARPxw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 10:53:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052Ab0ARPxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 10:53:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53538 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754185Ab0ARPxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 10:53:50 -0500
Date: Mon, 18 Jan 2010 16:53:47 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Michal Marek <mmarek@suse.cz>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] kbuild: improve version string logic
In-Reply-To: <4B5442CC.8050200@suse.cz>
Message-ID: <alpine.LRH.2.00.1001181652140.15694@twin.jikos.cz>
References: <alpine.DEB.2.00.1001041330230.26148@chino.kir.corp.google.com> <4B4345AF.9040600@suse.cz> <alpine.DEB.2.00.1001131300360.26527@chino.kir.corp.google.com> <20100116063754.GC20342@elte.hu> <20100116183445.29fc5d50.sfr@canb.auug.org.au>
 <20100116092658.GA23999@elte.hu> <4B542C99.9000801@suse.cz> <alpine.DEB.2.00.1001180243300.20677@chino.kir.corp.google.com> <4B5442CC.8050200@suse.cz>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jan 2010, Michal Marek wrote:

> > Michal, where are you hosting your git tree?  Are you going to be taking 
> > over kbuild-next on git.kernel.org?
> 
> git://repo.or.cz/linux-kbuild.git for-next
> (http://repo.or.cz/w/linux-kbuild.git). Maybe I should ask for an
> account in git.kernel.org account and move it there, you're not the
> first one to wonder where to find the tree :).

Yes, I think it is preferred.

I know, I know, the proper URL is listed in MAINTAINERS file ... still, I 
believe that what most people do when looking for particular git tree is 
going to http://git.kernel.org/ and looking around there.

So having the tree there really helps to give it much more exposure than 
on some random git hosting.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

