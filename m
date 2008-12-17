Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758700AbYLQITt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758700AbYLQITt (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 03:19:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbYLQITf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 03:19:35 -0500
Received: from ns1.suse.de ([195.135.220.2]:58604 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbYLQITe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 03:19:34 -0500
Date: Wed, 17 Dec 2008 09:19:32 +0100
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hugh@veritas.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 0/7] x86 PAT: v2 - track pfnmap mappings with remap_pfn_range and vm_insert_pfn
Message-ID: <20081217081932.GC26179@wotan.suse.de>
References: <20081126002157.475142000@intel.com> <7E82351C108FA840AB1866AC776AEC464338C11E@orsmsx505.amr.corp.intel.com> <20081216195154.GB4501@elte.hu> <20081216220502.GC22722@wotan.suse.de> <20081216220746.GE14787@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081216220746.GE14787@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 11:07:46PM +0100, Ingo Molnar wrote:
> 
> * Nick Piggin <npiggin@suse.de> wrote:
> > > So when you sent this a month ago i asked the MM folks whether they have 
> > > any problems with these patches. Acks (or objections) from Andrew, Nick or 
> > > Hugh would be nice to have.
> > 
> > Last I looked at them, I think all my questions were cleared up.
> 
> does that transform into a:
> 
>   Acked-by: Nick Piggin <npiggin@suse.de>

I should think so ;), but I'll take another glance at the next round
after Andrew's comments were incorporated. Are those available?
