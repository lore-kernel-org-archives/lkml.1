Return-Path: <linux-kernel-owner+w=401wt.eu-S1754138AbXD0Had@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbXD0Had (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 03:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754140AbXD0Hac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 03:30:32 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42710 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754138AbXD0Hab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 03:30:31 -0400
Date: Fri, 27 Apr 2007 00:29:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-Id: <20070427002947.ebe7e7ac.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704270020280.5501@schroedinger.engr.sgi.com>
References: <20070424222105.883597089@sgi.com>
	<20070426190438.3a856220.akpm@linux-foundation.org>
	<20070427022731.GF65285596@melbourne.sgi.com>
	<20070426195357.597ffd7e.akpm@linux-foundation.org>
	<20070427042046.GI65285596@melbourne.sgi.com>
	<20070426221528.655d79cb.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704262239580.4758@schroedinger.engr.sgi.com>
	<20070426235542.bad7035a.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704270020280.5501@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007 00:22:26 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:

> I will submit pieces to mm depending on the 
> outcome of our discussions.

Thanks.

There's a ludicrous amount of MM work pending in -mm.  It would probably be
less work at your end to see what ends up landing in 2.6.22-rc1.

<wanders off to do his mm-merge-plans email>
