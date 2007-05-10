Return-Path: <linux-kernel-owner+w=401wt.eu-S1762709AbXEJXBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762709AbXEJXBr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 19:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754359AbXEJXBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 19:01:40 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:42922 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754068AbXEJXBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 19:01:40 -0400
Date: Thu, 10 May 2007 16:01:39 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@skynet.skynet.ie>
cc: Nicolas.Mailhot@LaPoste.net, Andrew Morton <akpm@linux-foundation.org>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>
Subject: Re: [Bug 8464] New: autoreconf: page allocation failure. order:2,
 mode:0x84020
In-Reply-To: <20070510230044.GB15332@skynet.ie>
Message-ID: <Pine.LNX.4.64.0705101601220.14471@schroedinger.engr.sgi.com>
References: <200705102128.l4ALSI2A017437@fire-2.osdl.org>
 <20070510144319.48d2841a.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705101447120.12874@schroedinger.engr.sgi.com>
 <20070510220657.GA14694@skynet.ie> <Pine.LNX.4.64.0705101510500.13404@schroedinger.engr.sgi.com>
 <20070510221607.GA15084@skynet.ie> <Pine.LNX.4.64.0705101522250.13504@schroedinger.engr.sgi.com>
 <20070510224441.GA15332@skynet.ie> <Pine.LNX.4.64.0705101547020.14064@schroedinger.engr.sgi.com>
 <20070510230044.GB15332@skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2007, Mel Gorman wrote:

> Nicholas, could you backout the patch
> dont-group-high-order-atomic-allocations.patch and test again please?
> The following patch has the same effect. Thanks

Great! Thanks.
