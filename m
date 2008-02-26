Return-Path: <linux-kernel-owner+w=401wt.eu-S1764876AbYBZUHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764876AbYBZUHB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 15:07:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbYBZUGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 15:06:51 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:50883 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752519AbYBZUGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 15:06:50 -0500
Date: Tue, 26 Feb 2008 22:05:45 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>, mikael.starvik@axis.com,
       dev-etrax@axis.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch v2] cris: proper defconfig setup
Message-ID: <20080226200545.GG4898@cs181133002.pp.htv.fi>
References: <20080226172847.GB8287@cs181133002.pp.htv.fi> <20080226174703.GD8287@cs181133002.pp.htv.fi> <20080226180402.GH24124@axis.com> <20080226194453.GB31438@uranus.ravnborg.org> <20080226195257.GA4898@cs181133002.pp.htv.fi> <20080226195802.GD31438@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080226195802.GD31438@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 08:58:02PM +0100, Sam Ravnborg wrote:
> > 
> > Please name the tools that are that broken that they wouldn't apply this 
> > patch correctly and don't claim my patch was broken (or shut up).
> 
> It is only one or two weeks ago we ended up with a zero size file
> in the kernel tree - and I do not know why.
> I just wanted to make sure we did not see this happen again.

Then research first what went wrong in this case.

But it is not funny when you wrongly accuse me publically of sending 
patches that would remove files in an incorrect way.

> 	Sam

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

