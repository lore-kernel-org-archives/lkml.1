Return-Path: <linux-kernel-owner+w=401wt.eu-S1758483AbZDQBvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758483AbZDQBvP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 21:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754350AbZDQBu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 21:50:59 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:55716 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095AbZDQBu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 21:50:58 -0400
Date: Fri, 17 Apr 2009 07:20:04 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       randy.dunlap@oracle.com, menage@google.com, chlunde@ping.uio.no,
       eric.rannaud@gmail.com, fernando@oss.ntt.co.jp,
       Andrea Righi <righi.andrea@gmail.com>, dradford@bluehost.com,
       agk@sourceware.org, subrata@linux.vnet.ibm.com, axboe@kernel.dk,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dave@linux.vnet.ibm.com, matt@bluehost.com, roberto@unbit.it,
       ngupta@google.com
Subject: Re: [PATCH 3/9] bio-cgroup controller
Message-ID: <20090417015004.GC18558@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1239740480-28125-1-git-send-email-righi.andrea@gmail.com> <1239740480-28125-4-git-send-email-righi.andrea@gmail.com> <20090416152937.b2188370.akpm@linux-foundation.org> <20090417092040.1c832c69.kamezawa.hiroyu@jp.fujitsu.com> <20090416174428.6bb5da21.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090416174428.6bb5da21.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton <akpm@linux-foundation.org> [2009-04-16 17:44:28]:

> > Hmm, how about iotrack-cgroup ?
> > 
> 
> Well. blockio_cgroup has the same character count and is more specific.

Sounds good to me.

-- 
	Balbir
