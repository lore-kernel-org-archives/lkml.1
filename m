Return-Path: <linux-kernel-owner+w=401wt.eu-S1755142AbZDUPOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbZDUPOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 11:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752341AbZDUPOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 11:14:00 -0400
Received: from gir.skynet.ie ([193.1.99.77]:36337 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413AbZDUPN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 11:13:59 -0400
Date: Tue, 21 Apr 2009 16:13:55 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 11/25] Calculate the cold parameter for allocation only
	once
Message-ID: <20090421151355.GA29083@csn.ul.ie>
References: <1237543392-11797-1-git-send-email-mel@csn.ul.ie> <1237543392-11797-12-git-send-email-mel@csn.ul.ie> <alpine.DEB.1.10.0903201109250.3740@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0903201109250.3740@qirst.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 11:09:40AM -0400, Christoph Lameter wrote:
> 
> Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
> 

I apologise, I've it added now. While the patch is currently dropped from the
set, I'll bring it back later for further discussion when it can be
established if it really helps or not.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
