Return-Path: <linux-kernel-owner+w=401wt.eu-S1763374AbXF0Uaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763374AbXF0Uaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 16:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756554AbXF0Ua2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 16:30:28 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:14711 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200AbXF0Ua1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 16:30:27 -0400
Date: Wed, 27 Jun 2007 16:30:23 -0400
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: change _map_single to static in pci_gart.c etc
Message-ID: <20070627203023.GD4344@rhun.congress.lan>
References: <200706271041.21937.yinghai.lu@sun.com> <20070627202110.GA4344@rhun.congress.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070627202110.GA4344@rhun.congress.lan>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2007 at 04:21:10PM -0400, Muli Ben-Yehuda wrote:
> On Wed, Jun 27, 2007 at 10:41:21AM -0700, Yinghai Lu wrote:
> > [PATCH] x86_64: change _map_single to static in pci_gart.c etc
> > 
> > there function is called via dma_ops->.., so change it to static
> 
> Thanks, mostly looks good - will verify and push via the next set of
> Calgary updates.

Sorry, should've read the patch more carefully - above applies to
Calgary bits only.

Chers,
Muli
