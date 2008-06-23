Return-Path: <linux-kernel-owner+w=401wt.eu-S1760471AbYFWRm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760471AbYFWRm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 13:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754323AbYFWRmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 13:42:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41402 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754439AbYFWRmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 13:42:18 -0400
Date: Mon, 23 Jun 2008 10:42:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg Ungerer <gerg@snapgear.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org
Subject: Re: [PATCH] m68knommu: ColdFire add support for kernel preemption
Message-Id: <20080623104204.4e5bcea0.akpm@linux-foundation.org>
In-Reply-To: <485FA3BC.5080807@snapgear.com>
References: <200805010216.m412GT6t004096@goober>
	<20080501143336.552e39e1.akpm@linux-foundation.org>
	<481AC07A.6080707@snapgear.com>
	<20080502083755.GA13973@Chamillionaire.breakpoint.cc>
	<20080502052235.eb9c336a.akpm@linux-foundation.org>
	<485F3585.2080606@snapgear.com>
	<20080622225102.5117f22b.akpm@linux-foundation.org>
	<20080623175326.ddf5d2d4.sfr@canb.auug.org.au>
	<485FA3BC.5080807@snapgear.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2008 23:23:08 +1000 Greg Ungerer <gerg@snapgear.com> wrote:

> Do I need to send a request to Linus to pull this into his
> tree during the next merge window?

Yes, you do - nothing has changed in that regard.

>  Or will it migrate up
> from linux-next?

Nope, linux-next is a testing tree only.
