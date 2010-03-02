Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab0CBMzl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 07:55:41 -0500
Received: from one.firstfloor.org ([213.235.205.2]:48305 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab0CBMzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 07:55:40 -0500
Date: Tue, 2 Mar 2010 13:55:38 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, haicheng.li@intel.com,
       rientjes@google.com, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] [4/4] SLAB: Fix node add timer race in cache_reap
Message-ID: <20100302125538.GE19208@basil.fritz.box>
References: <20100215103250.GD21783@one.firstfloor.org> <20100215104135.GM5723@laptop> <20100215105253.GE21783@one.firstfloor.org> <20100215110135.GN5723@laptop> <alpine.DEB.2.00.1002191222320.26567@router.home> <20100220090154.GB11287@basil.fritz.box> <alpine.DEB.2.00.1002240949140.26771@router.home> <4B862623.5090608@cs.helsinki.fi> <alpine.DEB.2.00.1002251232550.18861@router.home> <4B86C58B.5040906@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B86C58B.5040906@cs.helsinki.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The first set of patches from Andi are almost one month old. If this issue 
> progresses as swiftly as it has to this day, I foresee a rocky road for any 

Yes it seems to be a bike shedding area for some reason (which color
should we paint it today?)

> of them getting merged to .34 through slab.git, that's all.

IMHO they are all bug fixes and there is no excuse for not merging them ASAP,
independent of any merge windows.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
