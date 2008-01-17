Return-Path: <linux-kernel-owner+w=401wt.eu-S1760069AbYAQVuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760069AbYAQVuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 16:50:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759886AbYAQVtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 16:49:06 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:50509 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759879AbYAQVtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 16:49:04 -0500
Date: Thu, 17 Jan 2008 23:47:55 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Willy Tarreau <w@1wt.eu>
Cc: Jiri Kosina <jikos@jikos.cz>, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.16.58
Message-ID: <20080117214755.GB28233@does.not.exist>
References: <20080115221832.GA4449@does.not.exist> <Pine.LNX.4.64.0801161703190.15647@twin.jikos.cz> <20080117203416.GK23696@does.not.exist> <20080117211205.GE8953@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080117211205.GE8953@1wt.eu>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 10:12:05PM +0100, Willy Tarreau wrote:
> Hi Adrian,
> 
> On Thu, Jan 17, 2008 at 10:34:16PM +0200, Adrian Bunk wrote:
> > do you insist on hearing the truth ("Sorry, I forgot to push."), or can 
> > I tell you "I just wanted to see whether anyone notices." instead?  ;-)
> 
> :-)
> 
> I think we should intentionally do this test once in a while. Two days
> ago I was informed that 2.6.20.21 (the latest 2.6.20 I pushed 3 months
> ago) was not clonable nor pullable due to a problem with the HEAD
> pointing to latest tag instead of latest commit. Since the error was
> also present in my local tree, I'm certain that it remained there
> unnoticed for 3 months !

According to git [1] Ralf merged 2.6.20.21 on 2007-10-18 into the 2.6.20 
branch of his mips tree, so it must have been somehow possible...

> Cheers,
> Willy

cu
Adrian

[1] http://www.linux-mips.org/git?p=linux.git;a=shortlog;h=linux-2.6.20-stable

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

