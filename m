Return-Path: <linux-kernel-owner+w=401wt.eu-S1757533AbZHGLNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533AbZHGLNB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 07:13:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757110AbZHGLNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 07:13:00 -0400
Received: from gir.skynet.ie ([193.1.99.77]:37923 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757164AbZHGLNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 07:13:00 -0400
Date: Fri, 7 Aug 2009 12:13:01 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: "Li, Ming Chun" <macli@brc.ubc.ca>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 4/6] tracing, page-allocator: Add a postprocessing
	script for page-allocator-related ftrace events
Message-ID: <20090807111300.GE18134@csn.ul.ie>
References: <1249574827-18745-1-git-send-email-mel@csn.ul.ie> <1249574827-18745-5-git-send-email-mel@csn.ul.ie> <alpine.DEB.1.00.0908061358250.13451@mail.selltech.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.00.0908061358250.13451@mail.selltech.ca>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 02:07:33PM -0700, Li, Ming Chun wrote:
> On Thu, 6 Aug 2009, Mel Gorman wrote:
> 
> Code style nitpick, There are four trailing whitespace errors while 
> applying this script patch, use ./scripts/checkpatch.pl would tell which 
> lines have trailing whitespace.
> 

Fixed now. I had been ignoring the checkpatch output to some extent as
it were so many warnings about the formatting. It was one of those
cases where it looked better without checkpatch but that's no excuse for
the whitespace :)

Thanks

> <SNIP>

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
