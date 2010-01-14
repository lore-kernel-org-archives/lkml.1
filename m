Return-Path: <linux-kernel-owner+w=401wt.eu-S1756515Ab0ANIax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515Ab0ANIax (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 03:30:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756232Ab0ANIax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 03:30:53 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36815 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab0ANIaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 03:30:52 -0500
Date: Thu, 14 Jan 2010 09:30:48 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matt Mackall <mpm@selenic.com>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.33 pagemap endless read loop
Message-ID: <20100114083048.GC12241@basil.fritz.box>
References: <20100110020955.GB25323@basil.fritz.box> <20100113141648.42eff724.akpm@linux-foundation.org> <1263421562.29868.5000.camel@calx> <20100113143055.7bea30c5.akpm@linux-foundation.org> <1263423916.29868.5009.camel@calx> <20100113151502.fa425247.akpm@linux-foundation.org> <20100114055319.GA17671@localhost> <20100113221013.b1beecb4.akpm@linux-foundation.org> <20100114080600.GA4739@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100114080600.GA4739@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ---
> pagemap: early return on unmapped areas

Yes seems like a reasonable idea.

-Andi

