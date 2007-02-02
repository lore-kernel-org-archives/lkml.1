Return-Path: <linux-kernel-owner+w=401wt.eu-S1030194AbXBBCQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030194AbXBBCQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 21:16:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030196AbXBBCQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 21:16:23 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:40156 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030194AbXBBCQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 21:16:22 -0500
Date: Thu, 1 Feb 2007 18:16:05 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Ethan Solomita <solo@google.com>
cc: akpm@osdl.org, Paul Menage <menage@google.com>,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       linux-mm@kvack.org, Andi Kleen <ak@suse.de>, Paul Jackson <pj@sgi.com>,
       Dave Chinner <dgc@sgi.com>
Subject: Re: [RFC 0/8] Cpuset aware writeback
In-Reply-To: <45C2960B.9070907@google.com>
Message-ID: <Pine.LNX.4.64.0702011815240.9799@schroedinger.engr.sgi.com>
References: <20070116054743.15358.77287.sendpatchset@schroedinger.engr.sgi.com>
 <45C2960B.9070907@google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Feb 2007, Ethan Solomita wrote:

>    Hi Christoph -- has anything come of resolving the NFS / OOM concerns that
> Andrew Morton expressed concerning the patch? I'd be happy to see some
> progress on getting this patch (i.e. the one you posted on 1/23) through.

Peter Zilkstra addressed the NFS issue. I will submit the patch again as 
soon as the writeback code stabilizes a bit.

