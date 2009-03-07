Return-Path: <linux-kernel-owner+w=401wt.eu-S1755239AbZCGFxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbZCGFxi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 00:53:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754883AbZCGFx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 00:53:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:35306 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755132AbZCGFxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 00:53:25 -0500
Message-ID: <49B20BD9.70509@kernel.org>
Date: Sat, 07 Mar 2009 14:53:29 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Cliff Wickman <cpw@sgi.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH v2] x86: UV uv_flush_tlb_others WARN_ON
References: <E1LfjVI-0006v9-MG@eag09.americas.sgi.com>
In-Reply-To: <E1LfjVI-0006v9-MG@eag09.americas.sgi.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 07 Mar 2009 05:53:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cliff Wickman wrote:
> From: Cliff Wickman <cpw@sgi.com>
> 
> The problem WARN_ON remains in Ingo's tree, and linux-next.
> It should be dropped.

Sorry, I must have lost it while tinkering with branches.  Added to
#tj-percpu.  Ingo, the patch is on top of the locking granuality
patchset.  Pulling #tj-percpu will include this one too.

Thanks.

-- 
tejun
