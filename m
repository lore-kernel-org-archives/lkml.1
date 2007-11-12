Return-Path: <linux-kernel-owner+w=401wt.eu-S1758997AbXKLQcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758997AbXKLQcp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 11:32:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304AbXKLQci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 11:32:38 -0500
Received: from mga10.intel.com ([192.55.52.92]:19201 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751250AbXKLQch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 11:32:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,406,1188802800"; 
   d="scan'208";a="379447183"
Date: Sun, 11 Nov 2007 20:26:18 -0800
From: mark gross <mgross@linux.intel.com>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-mm1 breaks C-state support on Intel T7200 x86_64
Message-ID: <20071112042618.GA439@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <3624.1194542384@turing-police.cc.vt.edu> <20071108223007.GB5775@linux.intel.com> <6010.1194639884@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6010.1194639884@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2007 at 03:24:44PM -0500, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 08 Nov 2007 14:30:07 PST, Mark Gross said:
> 
> > wing patch fixes up the cpuidle / pm-qos integration.
> > 
> > I suspect that this is folded into another mm patch but it should fix
> > C-state issue identified.
> 
> Confirming that patch left my CPUs mostly in C3 again. Thanks.
> 
> I'll have to let Mark and Andrew figure out this code's status in the -mm queue.

I checked on this last week, I'm pretty sure its in Andrew's current
tree.

Thanks again for looking at this.

--mgross
