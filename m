Return-Path: <linux-kernel-owner+w=401wt.eu-S1753498AbYI2Iyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbYI2Iyj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 04:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbYI2Iya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 04:54:30 -0400
Received: from gate.crashing.org ([63.228.1.57]:37537 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731AbYI2Iya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 04:54:30 -0400
Subject: Re: Fix PCI in Holly device tree
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: paulus@samba.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       David Gibson <david@gibson.dropbear.id.au>
In-Reply-To: <20080925122241.GC2243@yoda.jdub.homelinux.org>
References: <20080925023904.GC15169@yookeroo.seuss>
	 <20080925081129.7f882085@zod.rchland.ibm.com>
	 <20080925122241.GC2243@yoda.jdub.homelinux.org>
Content-Type: text/plain
Date: Mon, 29 Sep 2008 18:53:03 +1000
Message-Id: <1222678383.7807.97.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> >
> >Acked-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>
> >
> >Paul, I can include this in my 'next' branch if you aren't opposed.
> >I'll have another set of patches going in there today/tomorrow.
> 
> Er... on second thought, this actually fixes a regression on Holly.  So
> I'll amend my offer to put it in my 'next' branch to be contingent on you
> not wanting to get it into 2.6.27 this late.

I've picked it up, I need to check a thing or two and I'll send patches
for .27 to Linus tomorrow (Paulus is on vacation for a week). With a bit
of luck he won't have closed .27 before that :-)

Cheers
Ben.


