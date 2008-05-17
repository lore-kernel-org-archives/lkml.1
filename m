Return-Path: <linux-kernel-owner+w=401wt.eu-S1760723AbYEQWza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760723AbYEQWza (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 18:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbYEQWzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 18:55:21 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:51436 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766AbYEQWzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 18:55:20 -0400
Date: Sun, 18 May 2008 01:53:25 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Tracking and crediting bug reporters
Message-ID: <20080517225325.GD8140@cs181133002.pp.htv.fi>
References: <20080513102849.GB25196@cs181133002.pp.htv.fi> <18918.1210955743@vena.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <18918.1210955743@vena.lwn.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 10:35:43AM -0600, Jonathan Corbet wrote:
> [Operating in delayed response mode, sorry...]
> 
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > In which format do you want data for commits already in 2.6.26?
> 
> I hadn't thought about trying to backfill data for existing commits;
> that sounds like a fair amount of work for coverage which could still be
> somewhat spotty.  If you have the data at hand, though, then a simple
> file of the form
> 
> 	commit-id  full-name <email>

How to indicate whether it's a Reported-by or a Bisected-by?

> could be dealt with. But is it really worth the effort?

Not sure whether you don't consider it important that the data you 
publish is correct, but I will contribute the data I know about.

> Thanks,
> 
> jon

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

