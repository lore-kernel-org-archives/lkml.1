Return-Path: <linux-kernel-owner+w=401wt.eu-S1761719AbYENRar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761719AbYENRar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 13:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756136AbYENRah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 13:30:37 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50833 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755649AbYENRag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 13:30:36 -0400
Date: Wed, 14 May 2008 10:30:35 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Andi Kleen <andi@firstfloor.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, mpm@selenic.com,
       Matthew Wilcox <matthew@wil.cx>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: [patch 21/21] slab defrag: Obsolete SLAB
In-Reply-To: <84144f020805120323x38e5c657v97e4aec8d334de6f@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0805141029560.15194@schroedinger.engr.sgi.com>
References: <20080510030831.796641881@sgi.com>  <20080510030919.604216074@sgi.com>
 <4825709A.2020407@firstfloor.org>  <20080510221515.3540a6cc@bree.surriel.com>
  <2f11576a0805120038s334dc56cuaf16b8b7c6f87098@mail.gmail.com> 
 <84144f020805120054t1370236ei5ff52279457e026e@mail.gmail.com> 
 <20080512100846.GI31954@one.firstfloor.org>
 <84144f020805120323x38e5c657v97e4aec8d334de6f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2008, Pekka Enberg wrote:

> I only recently started tracking this issue so I have no idea where
> we're at with this. Christoph? Matthew?

I suspect that this is the same issue as tbench. I have explained the SLAB 
vs. SLUB free situation in another email in this thread.

