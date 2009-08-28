Return-Path: <linux-kernel-owner+w=401wt.eu-S1752494AbZH1Ir4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494AbZH1Ir4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 04:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752458AbZH1Ir4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 04:47:56 -0400
Received: from gir.skynet.ie ([193.1.99.77]:40729 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456AbZH1Irz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 04:47:55 -0400
Date: Fri, 28 Aug 2009 09:47:58 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] Reduce searching in the page allocator fast-path
Message-ID: <20090828084758.GA5054@csn.ul.ie>
References: <1251449067-3109-1-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1251449067-3109-1-git-send-email-mel@csn.ul.ie>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 28, 2009 at 09:44:25AM +0100, Mel Gorman wrote:
> The following two patches remove searching in the page allocator fast-path

Gack, and of course the subject should have been PATCH 0/2

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
