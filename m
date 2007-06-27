Return-Path: <linux-kernel-owner+w=401wt.eu-S1762331AbXF0UV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762331AbXF0UV2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 16:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753968AbXF0UVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 16:21:21 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:50332 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbXF0UVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 16:21:19 -0400
Date: Wed, 27 Jun 2007 16:21:10 -0400
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: change _map_single to static in pci_gart.c etc
Message-ID: <20070627202110.GA4344@rhun.congress.lan>
References: <200706271041.21937.yinghai.lu@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706271041.21937.yinghai.lu@sun.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2007 at 10:41:21AM -0700, Yinghai Lu wrote:
> [PATCH] x86_64: change _map_single to static in pci_gart.c etc
> 
> there function is called via dma_ops->.., so change it to static

Thanks, mostly looks good - will verify and push via the next set of
Calgary updates.

Cheers,
Muli
