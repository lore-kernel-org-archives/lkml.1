Return-Path: <linux-kernel-owner+w=401wt.eu-S1755226AbXEASDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbXEASDy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 14:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755231AbXEASDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 14:03:53 -0400
Received: from amsfep17-int.chello.nl ([213.46.243.15]:24769 "EHLO
	amsfep13-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755226AbXEASDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 14:03:52 -0400
Subject: Re: 2.6.22 -mm merge plans -- lumpy reclaim
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Mel Gorman <mel@skynet.ie>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, clameter@sgi.com,
       y-goto@jp.fujitsu.com
In-Reply-To: <46373A71.4030200@shadowen.org>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
	 <20070501101651.GA29957@skynet.ie>  <46373A71.4030200@shadowen.org>
Content-Type: text/plain
Date: Tue, 01 May 2007 20:03:49 +0200
Message-Id: <1178042629.24217.5.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-01 at 14:02 +0100, Andy Whitcroft wrote:

> Perhaps Peter would have some time to take a look over the latest stack
> as it appears in -mm when that releases; ping me for a patch kit if you
> want it before then :).

Lumpy-reclaim -v7, as per the roll-up provided privately;

Code is looking good, I like what you did to it :-)

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

