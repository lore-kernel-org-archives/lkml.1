Return-Path: <linux-kernel-owner+w=401wt.eu-S1763222AbXGKLPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763222AbXGKLPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 07:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760879AbXGKLOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 07:14:50 -0400
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:43192 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756678AbXGKLOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 07:14:49 -0400
Date: Wed, 11 Jul 2007 05:14:46 -0600
From: Andreas Dilger <adilger@clusterfs.com>
To: Mingming Cao <cmm@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [EXT4 set 3][PATCH 1/1] ext4 nanosecond timestamp
Message-ID: <20070711111446.GO6417@schatzie.adilger.int>
Mail-Followup-To: Mingming Cao <cmm@us.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
References: <1183275416.4010.125.camel@localhost.localdomain> <20070710163027.1bf7e94e.akpm@linux-foundation.org> <1184119241.20193.27.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184119241.20193.27.camel@localhost.localdomain>
User-Agent: Mutt/1.4.1i
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 10, 2007  22:00 -0400, Mingming Cao wrote:
> On Tue, 2007-07-10 at 16:30 -0700, Andrew Morton wrote:
> > On Sun, 01 Jul 2007 03:36:56 -0400
> > Mingming Cao <cmm@us.ibm.com> wrote:
> > 
> > > This patch is a spinoff of the old nanosecond patches.
> > 
> > I don't know what the "old nanosecond patches" are.  A link to a suitable
> > changlog for those patches would do in a pinch.  Preferable would be to
> > write a proper changelog for this patch.
> > 
> I found the original patch
> http://marc.info/?l=linux-ext4&m=115091699809181&w=2
> 
> Andreas or Kalpak, is changelog from the original patch is accurate to
> apply here?

Mostly, yes, but the name of the feature flag has changed.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

