Return-Path: <linux-kernel-owner+w=401wt.eu-S1763582AbXH1T4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763582AbXH1T4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762863AbXH1T4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:56:06 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34068 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762793AbXH1T4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:56:04 -0400
Date: Tue, 28 Aug 2007 12:56:03 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Christoph Hellwig <hch@lst.de>
cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, "H. Peter Anvin" <hpa@zytor.com>,
       joern@lazybastard.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [35/36] Large blocksize support for ext2
In-Reply-To: <20070828192209.GB13883@lst.de>
Message-ID: <Pine.LNX.4.64.0708281255530.16473@schroedinger.engr.sgi.com>
References: <20070828190551.415127746@sgi.com> <20070828190736.220951776@sgi.com>
 <20070828192209.GB13883@lst.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Aug 2007, Christoph Hellwig wrote:

> On Tue, Aug 28, 2007 at 12:06:26PM -0700, clameter@sgi.com wrote:
> > Hmmm... Actually there is nothing additional to be done after the earlier
> > cleanup of the macros. So just modify copyright.
> 
> So you get a copyright line for some trivial macro cleanups?  Please
> drop this patch and rather put your copyright into places where you
> actually did major work..

Ok.

