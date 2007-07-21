Return-Path: <linux-kernel-owner+w=401wt.eu-S1763682AbXGUF5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763682AbXGUF5U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 01:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756466AbXGUF5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 01:57:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59058 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259AbXGUF5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 01:57:08 -0400
Date: Sat, 21 Jul 2007 07:57:06 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Fengguang Wu <wfg@mail.ustc.edu.cn>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/8] compacting file_ra_state
Message-ID: <20070721055706.GA5097@one.firstfloor.org>
References: <20070721035733.951838089@mail.ustc.edu.cn> <20070721035850.977231489@mail.ustc.edu.cn> <384990797.09024@ustc.edu.cn> <alpine.LFD.0.999.0707202126250.27249@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707202126250.27249@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 09:27:01PM -0700, Linus Torvalds wrote:
> 
> 
> On Sat, 21 Jul 2007, Fengguang Wu wrote:
> >
> > Sorry, forgot to prefix the patch titles with [readahead].
> > Should I repost?
> 
> Not for me, but on the other hand, I'd prefer for this to be in -mm a bit, 

Haven't the readahead patches already essentially been in -mm* for some time?
I thought the new patches were some some restructured code, but essentially
the tested algorithms? 

-Andi
