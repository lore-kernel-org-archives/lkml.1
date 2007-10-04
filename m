Return-Path: <linux-kernel-owner+w=401wt.eu-S1759320AbXJDR66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759320AbXJDR66 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 13:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755724AbXJDR6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 13:58:49 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:42870 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754490AbXJDR6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 13:58:48 -0400
Date: Thu, 4 Oct 2007 10:58:45 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Arjan van de Ven <arjan@infradead.org>
cc: Matthew Wilcox <willy@linux.intel.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: SLUB performance regression vs SLAB
In-Reply-To: <20071004105046.7b019fe8@laptopd505.fenrus.org>
Message-ID: <Pine.LNX.4.64.0710041056500.11525@schroedinger.engr.sgi.com>
References: <20070919033605.785839297@sgi.com> <200709280742.38262.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0709281014060.4713@schroedinger.engr.sgi.com>
 <200709281514.48293.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0710011343020.19779@schroedinger.engr.sgi.com>
 <20071004161621.GO12049@parisc-linux.org> <Pine.LNX.4.64.0710041034550.10854@schroedinger.engr.sgi.com>
 <20071004105046.7b019fe8@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Oct 2007, Arjan van de Ven wrote:

> Ok every time something says anything not 100% positive about SLUB you
> come back with "but it's fixed in the next patch set"... *every time*.

All I ask that people test the fixes that have been out there for the 
known issues. If there are remaining performance issues then lets figure 
them out and address them.
