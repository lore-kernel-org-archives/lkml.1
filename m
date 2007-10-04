Return-Path: <linux-kernel-owner+w=401wt.eu-S1762159AbXJDVMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762159AbXJDVMQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 17:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761124AbXJDVL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 17:11:56 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58649 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760849AbXJDVLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 17:11:55 -0400
Date: Thu, 4 Oct 2007 14:11:53 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Matthew Wilcox <matthew@wil.cx>
cc: David Miller <davem@davemloft.net>, arjan@infradead.org,
       willy@linux.intel.com, nickpiggin@yahoo.com.au, hch@lst.de,
       mel@skynet.ie, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, dgc@sgi.com, jens.axboe@oracle.com
Subject: Re: SLUB performance regression vs SLAB
In-Reply-To: <20071004205812.GQ12049@parisc-linux.org>
Message-ID: <Pine.LNX.4.64.0710041411060.12779@schroedinger.engr.sgi.com>
References: <20071004161621.GO12049@parisc-linux.org>
 <Pine.LNX.4.64.0710041034550.10854@schroedinger.engr.sgi.com>
 <20071004105046.7b019fe8@laptopd505.fenrus.org> <20071004.134834.112622292.davem@davemloft.net>
 <20071004205812.GQ12049@parisc-linux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Oct 2007, Matthew Wilcox wrote:

> Yet here we stand.  Christoph is aggressively trying to get slab removed
> from the tree.  There is a testcase which shows slub performing worse
> than slab.  It's not my fault I can't publish it.  And just because I
> can't publish it doesn't mean it doesn't exist.
> 
> Slab needs to not get removed until slub is as good a performer on this
> benchmark.

I agree with this .... SLAB will stay until we have worked through all the 
performance issues.

