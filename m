Return-Path: <linux-kernel-owner+w=401wt.eu-S1754489AbXE3Wgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbXE3Wgt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 18:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753727AbXE3Wgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 18:36:39 -0400
Received: from waste.org ([66.93.16.53]:42474 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753738AbXE3Wgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 18:36:38 -0400
Date: Wed, 30 May 2007 17:36:12 -0500
From: Matt Mackall <mpm@selenic.com>
To: David Miller <davem@davemloft.net>
Cc: kaber@trash.net, shemminger@linux-foundation.org,
       akpm@linux-foundation.org, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 3/4] Make net watchdog timers 1 sec jiffy aligned
Message-ID: <20070530223612.GR11115@waste.org>
References: <465DC598.5060407@trash.net> <20070530.125551.41636333.davem@davemloft.net> <20070530221039.GJ11166@waste.org> <20070530.152939.21591222.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070530.152939.21591222.davem@davemloft.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 03:29:39PM -0700, David Miller wrote:
> From: Matt Mackall <mpm@selenic.com>
> Date: Wed, 30 May 2007 17:10:39 -0500
> 
> > Are you agreeing that "it seems wasteful to add per-packet overhead"?
> > This patch is not doing that.
> 
> Yes, and I know that :-)

Is there a real reason for watchdog_timeo to be all over the map?

-- 
Mathematics is the supreme nostalgia of our time.
