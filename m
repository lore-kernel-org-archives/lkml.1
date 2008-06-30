Return-Path: <linux-kernel-owner+w=401wt.eu-S1763693AbYF3SVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763693AbYF3SVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 14:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760524AbYF3SUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 14:20:52 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:50852 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932324AbYF3SUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 14:20:51 -0400
Date: Mon, 30 Jun 2008 21:20:36 +0300
From: Adrian Bunk <bunk@kernel.org>
To: David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>, rtc-linux@googlegroups.com
Subject: Re: [patch 2.6.26-rc7] <linux/bcd.h> space reduction
Message-ID: <20080630182036.GB1536@cs181140183.pp.htv.fi>
References: <200806221954.37088.david-b@pacbell.net> <200806230015.49973.david-b@pacbell.net> <20080624215400.GA18252@cs181140183.pp.htv.fi> <200806291741.23711.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200806291741.23711.david-b@pacbell.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 29, 2008 at 05:41:23PM -0700, David Brownell wrote:
> On Tuesday 24 June 2008, Adrian Bunk wrote:
> > On Mon, Jun 23, 2008 at 12:15:49AM -0700, David Brownell wrote:
> > > Where would that be ... lib/bcd.c, always linked?
> > 
> > Sounds good.
> > 
> > > And if it goes
> > > that way I'd prefer bcd2bin() and bin2bcd(), not these names.  A
> > > small impetus to have LESS SOURCE CODE SHOUTING AT ME.
> > 
> > Sounds good, but start with SHOUTING COMPATIBILITY #DEFINES FOR THE 
> > EXISTING USERS and either clean them up later or let me do the cleanup.
> 
> Like this then (against RC8)?
>...

Looks good.
 
cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

