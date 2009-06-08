Return-Path: <linux-kernel-owner+w=401wt.eu-S1754244AbZFHKYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244AbZFHKYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 06:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbZFHKYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 06:24:11 -0400
Received: from gir.skynet.ie ([193.1.99.77]:49416 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752825AbZFHKYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 06:24:10 -0400
Date: Mon, 8 Jun 2009 11:24:10 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: starlight@binnacle.cx
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       stable@kernel.org, Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Eric B Munson <ebmunson@us.ibm.com>, Adam Litke <agl@us.ibm.com>,
       Andy Whitcroft <apw@canonical.com>, wli@movementarian.org
Subject: Re: [PATCH 0/2] Fixes for hugetlbfs-related problems on shared
	memory
Message-ID: <20090608102410.GB15377@csn.ul.ie>
References: <1243422749-6256-1-git-send-email-mel@csn.ul.ie> <6.2.5.6.2.20090606235223.05a10068@binnacle.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <6.2.5.6.2.20090606235223.05a10068@binnacle.cx>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 07, 2009 at 09:25:06PM -0400, starlight@binnacle.cx wrote:
> Mel,
> 
> Tried out the two new patches on 2.6.26.4 and everything is 
> working now.  The application that uncovered the issue works 
> perfectly and hugepages function sanely.
> 

Very cool. Thanks for testing.

> Thank you for the fix.
> 

Thank you for persisting the problem and coming up with the test cases that
reproduce it. Without both, this fix would not have been forthcoming. It's
very much appreciated.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
