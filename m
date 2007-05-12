Return-Path: <linux-kernel-owner+w=401wt.eu-S1761143AbXELCjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761143AbXELCjW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 22:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754546AbXELCjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 22:39:14 -0400
Received: from waste.org ([66.93.16.53]:49291 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753686AbXELCjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 22:39:13 -0400
Date: Fri, 11 May 2007 21:39:05 -0500
From: Matt Mackall <mpm@selenic.com>
To: Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: Re: [announce] Intel announces the PowerTOP utility for Linux
Message-ID: <20070512023904.GY11115@waste.org>
References: <4644F726.1050806@linux.intel.com> <20070512001718.GY11166@waste.org> <20070512014052.GA4082@co.sapo.pt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070512014052.GA4082@co.sapo.pt>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 12, 2007 at 02:40:52AM +0100, Jose Celestino wrote:
> Words by Matt Mackall [Fri, May 11, 2007 at 07:17:19PM -0500]:
> > On Fri, May 11, 2007 at 04:07:18PM -0700, Arjan van de Ven wrote:
> > > 
> > > What's eating the battery life of my laptop? Why isn't it many more 
> > > hours? Which software component causes the most power to be burned? 
> > > These are important questions without a good answer... until now.
> > 
> > I get:
> > 
> > No detailed statistics available; please enable the CONFIG_TIMER_STATS
> > kernel option
> > 
> 
> Must run as root (rw to /proc/timer_stats is needed).

That file doesn't exist, despite CONFIG_TIMER_STATS being in
/proc/config.gz.

-- 
Mathematics is the supreme nostalgia of our time.
