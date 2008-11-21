Return-Path: <linux-kernel-owner+w=401wt.eu-S1757641AbYKUQwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641AbYKUQwg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 11:52:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757121AbYKUQwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 11:52:20 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45107 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757044AbYKUQwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 11:52:19 -0500
Subject: Re: [PATCH 3/8] intel-iommu: move context entry defs out from
	dma_remapping.h
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, x86@kernel.org
In-Reply-To: <20081120191135.GB3955@elte.hu>
References: <1227191861.4901.24.camel@macbook.infradead.org>
	 <1227196190-488-1-git-send-email-markmc@redhat.com>
	 <1227196190-488-2-git-send-email-markmc@redhat.com>
	 <1227196190-488-3-git-send-email-markmc@redhat.com>
	 <20081120191135.GB3955@elte.hu>
Content-Type: text/plain
Date: Fri, 21 Nov 2008 16:50:58 +0000
Message-Id: <1227286258.3693.101.camel@blaa>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-20 at 20:11 +0100, Ingo Molnar wrote:

> Since you move this code, please also do a patch to clean it up to use 
> inlines, not macros.

Okay, coming up.

Cheers,
Mark.

