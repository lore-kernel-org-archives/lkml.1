Return-Path: <linux-kernel-owner+w=401wt.eu-S1758151AbYEMKaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151AbYEMKaa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 06:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbYEMKaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 06:30:21 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:34880 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbYEMKaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 06:30:20 -0400
Date: Tue, 13 May 2008 13:28:49 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Tracking and crediting bug reporters
Message-ID: <20080513102849.GB25196@cs181133002.pp.htv.fi>
References: <4388.1210613272@vena.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4388.1210613272@vena.lwn.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 11:27:52AM -0600, Jonathan Corbet wrote:
>...
> So here's what we would like to try instead.  Whenever somebody sends up a
> patch fixing a reported bug, the name of the person who reported the bug
> would be immortalized with this tag:
> 
> 	Reported-by: A. Bug Reporter <email@goes.here>
> 
> In particular, reporters who work with the developers toward the resolution
> of the bug should be thanked in this way.  If we wanted to take things
> further, perhaps we could add a Bisected-by: tag for really hard-core
> helpers. 

I assume it will be valid for one person to have two or all three tags 
in one commit (not uncommon for some of the stuff I'm doing)?

> If these tags go into the commit messages in any sort of consistent way, it
> should be possible generate the usual sort of statistics from them.  I'll
> then happily publicize them next to the traditional lists of people who are
> adding new bugs.  The result will certainly be fame, fortune, and job
> offers for the people at the top of the list.  Or something like that.
> 
> If the rest of the community is agreeable, it would be nice to make an
> immediate start on this; it's not yet too late to get reasonable data for
> the 2.6.26 kernel, and to have the habits well ingrained for 2.6.27.
>...

In which format do you want data for commits already in 2.6.26?

> jon

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

