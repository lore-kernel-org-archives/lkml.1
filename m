Return-Path: <linux-kernel-owner+w=401wt.eu-S1754001AbYLRVxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbYLRVxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 16:53:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752510AbYLRVxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 16:53:17 -0500
Received: from mga09.intel.com ([134.134.136.24]:28934 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243AbYLRVxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 16:53:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,245,1228118400"; 
   d="scan'208";a="475202152"
Date: Thu, 18 Dec 2008 13:53:14 -0800
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Nick Piggin <npiggin@suse.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "hugh@veritas.com" <hugh@veritas.com>,
       "arjan@infradead.org" <arjan@infradead.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "jeremy@goop.org" <jeremy@goop.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: [patch 4/7] x86 PAT: Implement track/untrack of pfnmap regions for x86 - v3
Message-ID: <20081218215313.GB31088@linux-os.sc.intel.com>
References: <20081218194126.963894000@intel.com> <20081218194617.533039000@intel.com> <20081218213806.GG10681@wotan.suse.de> <494AC358.6000103@zytor.com> <20081218214622.GB30834@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081218214622.GB30834@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2008 at 01:46:22PM -0800, Ingo Molnar wrote:
> 
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
> > Nick Piggin wrote:
> > > And that's the end of the mm/ code... yeah the mm/ parts seem OK to me,
> > > with my minor comments addressed I would ack them all.
> >
> > Great!
> >
> > Venki, can this be done with incremental patches, or would that be too
> > messy?
> 
> would be nice to have them as deltas. The patches are pushed out into
> tip/master already - and we'll push it towards linux-next once Nick's
> concerns have been addressed.
> 

Yes. I will send incremental patches over v3 addressing Nick's comments.

Thanks,
Venki
