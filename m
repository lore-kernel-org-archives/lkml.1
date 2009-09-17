Return-Path: <linux-kernel-owner+w=401wt.eu-S1753325AbZIQPVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbZIQPVG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 11:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753132AbZIQPVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 11:21:06 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:53996 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753163AbZIQPVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 11:21:04 -0400
Date: Thu, 17 Sep 2009 11:21:07 -0400
To: Michal Simek <monstr@monstr.eu>
Cc: microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org,
       Greg Ungerer <gerg@uclinux.org>,
       Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: Re: =?us-ascii?B?PT91cy1hc2NpaT9RPz01Qm1p?=
	=?us-ascii?B?Y3JvYmxhemU9MkR1Y2xpbnV4PTVEPTIwUmU9M0E9MjA9NUJQQVRDSD01RD0y?=
	=?us-ascii?Q?0Actually=3D20show=3D20KiB=3D20rather=3D20than=3D20pages=3D2?=
	=?us-ascii?Q?0in=3D20=3D22Freeing=3D20initrd?=
Message-ID: <20090917152107.GX23700@csclub.uwaterloo.ca>
References: <20090915165037.GA23702@csclub.uwaterloo.ca> <4AB1E78D.3070007@snapgear.com> <4AB1F9B0.10103@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB1F9B0.10103@monstr.eu>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 10:56:16AM +0200, Michal Simek wrote:
> Greg Ungerer wrote:
> > Hi Lennart,
> > 
> > Lennart Sorensen wrote:
> >> Fix "Freeing initrd memory:" message on h3800, m68knommu and microblaze
> >> to show kilobytes as claimed rather than number of pages.
> >>
> >> Signed-off-by: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
> > 
> > Looks ok to me. I can take and push the m68knommu part separately.
> > Or if Andrew wants to take it all as one, here is an:
> > 
> > Acked-by: Greg Ungerer <gerg@uclinux.org>
> 
> As Greg wrote. It will be the best to push it separately. IMHO it
> will be faster. It is up to you. If you want to add it to microblaze
> branch please send only patch for microblaze.
> 
> If not.
> 
> Acked-by: Michal Simek <monstr@monstr.eu>

Oh right how silly of me.  3 seperate patches would have been nicer I
guess.  The original code is certainly copied from one place to the others
although I have no idea which architecture was the first to get it wrong.

Would everyone prefer I made 3 patches instead and resent them?

-- 
Len Sorensen
