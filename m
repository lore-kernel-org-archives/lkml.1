Return-Path: <linux-kernel-owner+w=401wt.eu-S1764274AbXH1Tc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764274AbXH1Tc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762858AbXH1TVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:21:35 -0400
Received: from verein.lst.de ([213.95.11.210]:56550 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762998AbXH1TVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:21:33 -0400
Date: Tue, 28 Aug 2007 21:20:34 +0200
From: Christoph Hellwig <hch@lst.de>
To: clameter@sgi.com
Cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, "H. Peter Anvin" <hpa@zytor.com>,
       joern@lazybastard.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [00/36] Large Blocksize Support V6
Message-ID: <20070828192034.GA13883@lst.de>
References: <20070828190551.415127746@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070828190551.415127746@sgi.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stoooooopp!

This patchseries is entirely unacceptable!

one patch per file is the most braindead and most unacceptable way
to split a series.  Please stop whatever you're doing right now and
correct it and send out a patch that has one patch per logical change
for the whole tree.  This means people can actually read the patch,
and it's bisectable.
