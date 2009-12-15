Return-Path: <linux-kernel-owner+w=401wt.eu-S932589AbZLORGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932589AbZLORGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 12:06:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760645AbZLORGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 12:06:30 -0500
Received: from gir.skynet.ie ([193.1.99.77]:44512 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760644AbZLORG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 12:06:29 -0500
Date: Tue, 15 Dec 2009 17:06:22 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [this_cpu_xx V7 0/8] Per cpu atomics in core allocators and
	cleanup
Message-ID: <20091215170622.GA24739@csn.ul.ie>
References: <20091214220320.665065925@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20091214220320.665065925@quilx.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 04:03:20PM -0600, Christoph Lameter wrote:
> Leftovers from the earlier patchset. Mostly applications of per cpu counters
> to core components.
> 
> After this patchset there will be only one user of local_t left: Mathieu's
> trace ringbuffer. Does it really need these ops?
> 

What kernel are these patches based on? They do not cleanly apply and
when fixed up, they do not build against 2.6.32.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
