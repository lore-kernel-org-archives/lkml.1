Return-Path: <linux-kernel-owner+w=401wt.eu-S1758453AbXGUE1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758453AbXGUE1a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 00:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750734AbXGUE1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 00:27:22 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34772 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750710AbXGUE1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 00:27:21 -0400
Date: Fri, 20 Jul 2007 21:27:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/8] compacting file_ra_state
In-Reply-To: <384990797.09024@ustc.edu.cn>
Message-ID: <alpine.LFD.0.999.0707202126250.27249@woody.linux-foundation.org>
References: <20070721035733.951838089@mail.ustc.edu.cn>
 <20070721035850.977231489@mail.ustc.edu.cn> <384990797.09024@ustc.edu.cn>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 21 Jul 2007, Fengguang Wu wrote:
>
> Sorry, forgot to prefix the patch titles with [readahead].
> Should I repost?

Not for me, but on the other hand, I'd prefer for this to be in -mm a bit, 
even if it does mean missing the merge window this time around. 

		Linus
