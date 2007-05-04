Return-Path: <linux-kernel-owner+w=401wt.eu-S1031071AbXEDQL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031071AbXEDQL0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 12:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031080AbXEDQL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 12:11:26 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:38305 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031071AbXEDQLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 12:11:25 -0400
Date: Fri, 4 May 2007 09:11:19 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: David Chinner <dgc@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
In-Reply-To: <m1ejlwu346.fsf@ebiederm.dsl.xmission.com>
Message-ID: <Pine.LNX.4.64.0705040910330.21436@schroedinger.engr.sgi.com>
References: <20070424222105.883597089@sgi.com> <20070426190438.3a856220.akpm@linux-foundation.org>
 <20070427022731.GF65285596@melbourne.sgi.com> <20070426195357.597ffd7e.akpm@linux-foundation.org>
 <20070427042046.GI65285596@melbourne.sgi.com> <20070426221528.655d79cb.akpm@linux-foundation.org>
 <20070427060921.GA77450368@melbourne.sgi.com> <20070427000403.6013d1fa.akpm@linux-foundation.org>
 <20070427080321.GG32602149@melbourne.sgi.com> <m1ejlwu346.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 May 2007, Eric W. Biederman wrote:

> Given that small block sizes give us better storage efficiency,
> which means less disk bandwidth used, which means less time
> to get the data off of a slow disk (especially if you can
> put multiple files you want simultaneously in that same space).
> I'm not convinced that large block sizes are a clear disk performance
> advantage, so we should not neglect the small file sizes.

And the 50% gain in the benchmarks means what? That the device 
manufacturers have to redesign their chips?

