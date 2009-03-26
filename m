Return-Path: <linux-kernel-owner+w=401wt.eu-S1757192AbZCZJzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192AbZCZJzd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 05:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbZCZJzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 05:55:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37574 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397AbZCZJzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 05:55:23 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Fix Bug 10504 - losetup possible circular locking
Date: Thu, 26 Mar 2009 15:22:56 +0530
User-Agent: KMail/1.10.3 (Linux/2.6.27.19-3.2-default; KDE/4.1.3; x86_64; ; )
Cc: zdenek.kabelac@gmail.com, bunk@kernel.org, jirislaby@gmail.com,
       hidave.darkstar@gmail.com, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org, nikanth@gmail.com
References: <200903121341.13173.knikanth@suse.de> <200903261512.22775.knikanth@suse.de> <20090326094847.GN27476@kernel.dk>
In-Reply-To: <20090326094847.GN27476@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903261522.57041.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 March 2009 15:18:47 Jens Axboe wrote:
> On Thu, Mar 26 2009, Nikanth Karthikesan wrote:
> > On Tuesday 24 March 2009 17:00:32 Jens Axboe wrote:
> > > On Tue, Mar 24 2009, Nikanth Karthikesan wrote:
> > > > Hi Jens
> > > >
> > > > Did you get to look at this? Can you ACK/NACK this one?
> > >
> > > It looks fine, I have applied it.
> >
> > Thanks. But it looks like, the patch I quoted in the changelog had the
> > "---" delimiter, which made you commit without the full changelog and
> > signed-off. Sorry for that mistake.
>
> That was actually done on purpose, I wanted the whole thing there! It
> was a lot more useful than the short summary. Never be afraid to write
> exhaustive changelogs, I even put the test app in there for some cases
> when that makes sense.

Yes, but because of a delimiter '---' in my changelog, the git log has only 
half of the changelog. IOW, the whole thing is not there.

Thanks
Nikanth


