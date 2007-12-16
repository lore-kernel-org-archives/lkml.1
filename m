Return-Path: <linux-kernel-owner+w=401wt.eu-S1764082AbXLPV4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764082AbXLPV4X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 16:56:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761418AbXLPV4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 16:56:13 -0500
Received: from gir.skynet.ie ([193.1.99.77]:47894 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760803AbXLPV4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 16:56:11 -0500
Date: Sun, 16 Dec 2007 21:56:09 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Mark Lord <liml@rtr.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com,
       lkml@rtr.ca, matthew@wil.cx, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] fix page_alloc for larger I/O segments (improved)
Message-ID: <20071216215608.GB7710@csn.ul.ie>
References: <20071213142935.47ff19d9.akpm@linux-foundation.org> <4761B32A.3070201@rtr.ca> <4761BCB4.1060601@rtr.ca> <4761C8E4.2010900@rtr.ca> <4761CE88.9070406@rtr.ca> <20071213163726.3bb601fa.akpm@linux-foundation.org> <4761D160.7060603@rtr.ca> <4761D279.6050500@rtr.ca> <20071214174236.GA28613@csn.ul.ie> <4762C677.5040708@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4762C677.5040708@rtr.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (14/12/07 13:07), Mark Lord didst pronounce:
> <SNIP>
> 
> That (also) works for me here, regularly generating 64KB I/O segments with 
> SLAB.
> 

Brilliant. Thanks a lot Mark.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
