Return-Path: <linux-kernel-owner+w=401wt.eu-S1753828AbYLRVsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbYLRVsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 16:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbYLRVsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 16:48:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46697 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbYLRVsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 16:48:06 -0500
Message-ID: <494AC358.6000103@zytor.com>
Date: Thu, 18 Dec 2008 13:40:40 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: venkatesh.pallipadi@intel.com, mingo@elte.hu, tglx@linutronix.de,
       akpm@linux-foundation.org, hugh@veritas.com, arjan@infradead.org,
       jbarnes@virtuousgeek.org, rdreier@cisco.com, jeremy@goop.org,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch 4/7] x86 PAT: Implement track/untrack of pfnmap regions
 for x86 - v3
References: <20081218194126.963894000@intel.com> <20081218194617.533039000@intel.com> <20081218213806.GG10681@wotan.suse.de>
In-Reply-To: <20081218213806.GG10681@wotan.suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> And that's the end of the mm/ code... yeah the mm/ parts seem OK to me,
> with my minor comments addressed I would ack them all.

Great!

Venki, can this be done with incremental patches, or would that be too
messy?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

