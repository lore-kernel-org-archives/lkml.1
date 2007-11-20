Return-Path: <linux-kernel-owner+w=401wt.eu-S1763280AbXKTUin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763280AbXKTUin (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 15:38:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761532AbXKTUia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 15:38:30 -0500
Received: from relay1.sgi.com ([192.48.171.29]:55382 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762041AbXKTUia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 15:38:30 -0500
Date: Tue, 20 Nov 2007 12:38:29 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Christoph Hellwig <hch@infradead.org>
cc: ak@suse.de, akpm@linux-foundation.org, travis@sgi.com,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc 18/45] cpu alloc: XFS counters
In-Reply-To: <20071120081230.GA1324@infradead.org>
Message-ID: <Pine.LNX.4.64.0711201238010.26745@schroedinger.engr.sgi.com>
References: <20071120011132.143632442@sgi.com> <20071120011335.975705216@sgi.com>
 <20071120081230.GA1324@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007, Christoph Hellwig wrote:

> On Mon, Nov 19, 2007 at 05:11:50PM -0800, clameter@sgi.com wrote:
> > Also remove the useless zeroing after allocation. Allocpercpu already
> > zeroed the objects.
> 
> You still haven't answered my comment to the last iteration.

And you have not read the discussion on that subject in the prior 
iteration between Peter Zilkstra and me.


