Return-Path: <linux-kernel-owner+w=401wt.eu-S1755443AbXD0HW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbXD0HW2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 03:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754120AbXD0HW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 03:22:28 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:33840 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755444AbXD0HW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 03:22:27 -0400
Date: Fri, 27 Apr 2007 00:22:26 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
In-Reply-To: <20070426235542.bad7035a.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704270020280.5501@schroedinger.engr.sgi.com>
References: <20070424222105.883597089@sgi.com> <20070426190438.3a856220.akpm@linux-foundation.org>
 <20070427022731.GF65285596@melbourne.sgi.com> <20070426195357.597ffd7e.akpm@linux-foundation.org>
 <20070427042046.GI65285596@melbourne.sgi.com> <20070426221528.655d79cb.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704262239580.4758@schroedinger.engr.sgi.com>
 <20070426235542.bad7035a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007, Andrew Morton wrote:

> Were any cleanups made which were not also applicable as standalone things
> to mainline?

Ahh. I think I know what you mean. The current patchset is for performance 
testing against mainline. Lets first cover the bases and then see where 
we go. It is not against mm. I will submit pieces to mm depending on the 
outcome of our discussions.
