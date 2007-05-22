Return-Path: <linux-kernel-owner+w=401wt.eu-S1762164AbXEVBNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762164AbXEVBNR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 21:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757152AbXEVBNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 21:13:07 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:34170 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756786AbXEVBNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 21:13:06 -0400
Date: Mon, 21 May 2007 18:13:03 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <npiggin@suse.de>
cc: Matt Mackall <mpm@selenic.com>, William Lee Irwin III <wli@holomorphy.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-arch@vger.kernel.org
Subject: Re: [rfc] increase struct page size?!
In-Reply-To: <20070522010823.GC27743@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0705211812440.24359@schroedinger.engr.sgi.com>
References: <20070518040854.GA15654@wotan.suse.de>
 <Pine.LNX.4.64.0705181112250.11881@schroedinger.engr.sgi.com>
 <20070519012530.GB15569@wotan.suse.de> <20070519181501.GC19966@holomorphy.com>
 <20070520052229.GA9372@wotan.suse.de> <20070520084647.GF19966@holomorphy.com>
 <20070520092552.GA7318@wotan.suse.de> <20070521080813.GQ31925@holomorphy.com>
 <20070521092742.GA19642@wotan.suse.de> <20070521224316.GC11166@waste.org>
 <20070522010823.GC27743@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2007, Nick Piggin wrote:

> That would be unpopular with pagecache, because that uses pretty well
> all fields.

SLUB also uses all fields....

