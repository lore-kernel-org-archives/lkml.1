Return-Path: <linux-kernel-owner+w=401wt.eu-S1754872AbXINSPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbXINSPb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 14:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754350AbXINSPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 14:15:19 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60428 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753787AbXINSPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 14:15:17 -0400
Date: Fri, 14 Sep 2007 11:15:16 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Mel Gorman <mel@skynet.ie>, andrea@suse.de, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
In-Reply-To: <Pine.LNX.4.64.0709141053110.15813@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0709141114130.15965@schroedinger.engr.sgi.com>
References: <20070911060349.993975297@sgi.com> <200709121246.08833.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0709121607140.4204@schroedinger.engr.sgi.com>
 <200709140720.06537.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0709141053110.15813@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Sep 2007, Christoph Lameter wrote:

> an -ENOMEM. Given the quantities of pages on todays machine--a 1 G machine 

s/1G/1T/ Sigh.

> has 256 milllion 4k pages--and the unmovable ratios we see today it 

256k for 1G.

