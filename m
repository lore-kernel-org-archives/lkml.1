Return-Path: <linux-kernel-owner+w=401wt.eu-S1765078AbYDOPHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765078AbYDOPHE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 11:07:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756943AbYDOPGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 11:06:53 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:40844 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754609AbYDOPGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 11:06:53 -0400
Date: Tue, 15 Apr 2008 18:05:42 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Szabolcs Szakacsits <szaka@ntfs-3g.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, dwmw2@infradead.org, hch@infradead.org,
       me@bobcopeland.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
Message-ID: <20080415150542.GC2454@cs181133002.pp.htv.fi>
References: <10224488.783261208172602425.JavaMail.szaka@kolumbus.fi> <Pine.LNX.4.62.0804150102280.10583@tamago.serverit.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.62.0804150102280.10583@tamago.serverit.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 03:11:27AM +0300, Szabolcs Szakacsits wrote:
>...
> In my experience the huge difference is for users getting better quality 
> and faster support. It takes from several months to many years to get new 
> features and fixes to millions of user via kernel drivers but it takes a 
> matter of hours/days via user space binaries. This results a much faster, 
> quality and feature efficient release cycle.
> 
> The kernel part is indeed always the most problematic because fixes and new 
> things take very long time to arrive to end users.
>...

I don't think that's true:

Why does it have to take longer to distribute e.g. a new version of the 
ALSA kernel drivers to end users than to distribute a new version of 
userspace binaries to them?

> 	Szaka

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

