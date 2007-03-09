Return-Path: <linux-kernel-owner+w=401wt.eu-S2993136AbXCIVEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993136AbXCIVEH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 16:04:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993134AbXCIVEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 16:04:06 -0500
Received: from waste.org ([66.93.16.53]:41820 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993130AbXCIVED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 16:04:03 -0500
Date: Fri, 9 Mar 2007 14:51:22 -0600
From: Matt Mackall <mpm@selenic.com>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: 2.6.21-rc3-mm1 RSDL results
Message-ID: <20070309205122.GF10394@waste.org>
References: <20070309053931.GA10459@waste.org> <20070309182744.GC10394@waste.org> <200703100715.39354.kernel@kolivas.org> <200703100726.15517.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703100726.15517.kernel@kolivas.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2007 at 07:26:15AM +1100, Con Kolivas wrote:
> > How odd. I would have thought that if an interaction was to occur it would
> > have been without the new feature. Clearly what you describe without NO_HZ
> > is not the expected behaviour with RSDL. I wonder what went wrong. Are you
> > on 100HZ on that laptop? While I expect 100HZ should be ok, it might just
> > not be... My laptop is about the same performance and works fine with 100HZ
> > under load of all sorts BUT I don't have Beryl (which I would have thought
> > swayed things in the opposite direction also).

HZ=250

> Oh and can you grep dmesg for:
> Scheduler bitmap error

Nope, sorry.

-- 
Mathematics is the supreme nostalgia of our time.
