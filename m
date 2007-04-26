Return-Path: <linux-kernel-owner+w=401wt.eu-S1031376AbXDZR7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031376AbXDZR7A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031388AbXDZR7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:59:00 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50303 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031376AbXDZR67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 13:58:59 -0400
Date: Thu, 26 Apr 2007 10:58:57 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Mel Gorman <mel@skynet.ie>, Nick Piggin <nickpiggin@yahoo.com.au>,
       David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
In-Reply-To: <m1y7kfl837.fsf@ebiederm.dsl.xmission.com>
Message-ID: <Pine.LNX.4.64.0704261058050.3263@schroedinger.engr.sgi.com>
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com>
 <46303A98.9000605@yahoo.com.au> <20070426063830.GE32602149@melbourne.sgi.com>
 <46304B9E.5070604@yahoo.com.au> <20070426084012.GA26926@skynet.ie>
 <463068E5.6000402@yahoo.com.au> <20070426103014.GC27620@skynet.ie>
 <m1y7kfl837.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007, Eric W. Biederman wrote:

> I can't possibly believe any of this is about the cost of processing
> a request, but rather the problem that some devices don't have a large
> enough pool of requests to keep them busy if you submit the requests
> in a 4K page sizes.
> 
> This all sounds like a device design issue rather than anything more
> significant, and it doesn't sound like a long term trend.  Market
> pressure should fix the hardware.

Sounds like we are dictating device manufacturers how to 
design their devices instead of leaving them choice.

