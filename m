Return-Path: <linux-kernel-owner+w=401wt.eu-S1763562AbXEPSTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763562AbXEPSTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 14:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761446AbXEPSTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 14:19:31 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:57239 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763450AbXEPST3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 14:19:29 -0400
Date: Wed, 16 May 2007 20:16:46 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: david@lang.hm
cc: Andreas Dilger <adilger@clusterfs.com>, Jeff Zheng <Jeff.Zheng@endace.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Software raid0 will crash the file-system, when each disk is
 5TB
In-Reply-To: <Pine.LNX.4.64.0705161058430.1280@asgard.lang.hm>
Message-ID: <Pine.LNX.4.61.0705162016060.9019@yvahk01.tjqt.qr>
References: <659F626D666070439A4A5965CD6EBF406836C6@gazelle.ad.endace.com>
 <20070516140452.GC5286@schatzie.adilger.int> <Pine.LNX.4.64.0705161058430.1280@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 16 2007 11:04, david@lang.hm wrote:
>
> I'm getting ready to setup a similar machine that will have 3x10TB (3 15 disk
> arrays with 750G drives), but won't be ready to try this for a few more days.

You could emulate it with VMware. Big disks are quite "cheap" when
they are not allocated.


	Jan
-- 
