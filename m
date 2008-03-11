Return-Path: <linux-kernel-owner+w=401wt.eu-S1757084AbYCKUnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084AbYCKUnI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 16:43:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754318AbYCKUm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 16:42:56 -0400
Received: from mga03.intel.com ([143.182.124.21]:16867 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753944AbYCKUm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 16:42:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,482,1199692800"; 
   d="scan'208";a="217435622"
Subject: Re: [PATCH] pasemi_dma: Driver for PA Semi PWRficient on-chip DMA
	engine
From: Dan Williams <dan.j.williams@intel.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, hskinnemoen@atmel.com,
       "Nelson, Shannon" <shannon.nelson@intel.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       pasemi-linux@ozlabs.org, Olof Johansson <olof@lixom.net>
In-Reply-To: <F4B05C0E-99BB-4F60-BDD8-A79F07A81692@kernel.crashing.org>
References: <20080306233900.GA3969@lixom.net>
	 <20080311000619.ba39311f.akpm@linux-foundation.org>
	 <20080311142545.GA18843@lixom.net>
	 <20080311105355.64a9c380.akpm@linux-foundation.org>
	 <1205259311.26723.40.camel@dwillia2-linux.ch.intel.com>
	 <F4B05C0E-99BB-4F60-BDD8-A79F07A81692@kernel.crashing.org>
Content-Type: text/plain
Date: Tue, 11 Mar 2008 13:37:20 -0700
Message-Id: <1205267840.27495.9.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-8.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-03-11 at 11:29 -0700, Kumar Gala wrote:
> > My fault for not pushing out this cleanup to the old url while the
> > git-md-accel changeover was pending.
> 
> Any reason not to push Zhang's fixes for 2.6.25?

I plan to push these fixes for 2.6.25.  Olof had some valid comments
about "Fix fsldma.c warning messages..." [1].

> I also have a patch I want to push for 2.6.25 to deal with the powerpc 
> device tree.  I was going to handle this via the powerpc tree's since 
> that seems to be the model we have used for netdev and other drivers 
> that play with arch/powerpc.  I hope that's not an issue (I'll CC you 
> on the patch).

Not an issue at all.  Just give me a heads up on what you want me to
pick up and what you want me to just ack.

[1] http://marc.info/?l=linux-kernel&m=120524510630957&w=2

