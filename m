Return-Path: <linux-kernel-owner+w=401wt.eu-S1423370AbXDYSUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423370AbXDYSUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 14:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423365AbXDYSUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 14:20:18 -0400
Received: from brick.kernel.dk ([80.160.20.94]:16044 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423371AbXDYSUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 14:20:16 -0400
Date: Wed, 25 Apr 2007 20:16:43 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070425181643.GJ4730@kernel.dk>
References: <20070424222105.883597089@sgi.com> <20070425113530.GX9715@kernel.dk> <Pine.LNX.4.64.0704250833240.24452@schroedinger.engr.sgi.com> <20070425175335.GG4730@kernel.dk> <Pine.LNX.4.64.0704251101490.21918@schroedinger.engr.sgi.com> <20070425180528.GH4730@kernel.dk> <Pine.LNX.4.64.0704251113460.27844@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704251113460.27844@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25 2007, Christoph Lameter wrote:
> On Wed, 25 Apr 2007, Jens Axboe wrote:
> 
> > All of memory is lowmem. There are no bounces going on, for sure.
> 
> Could you figure out what this is? The patchset was intentionally only for 
> 64 bit. I cannot get to the 32 bit headaches for a week or so.

Sure, but I probably wont have cycles to throw at that until next
week... Come monday I'll see if I can pin point the problem(s).

-- 
Jens Axboe

