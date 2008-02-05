Return-Path: <linux-kernel-owner+w=401wt.eu-S1757851AbYBESMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757851AbYBESMv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 13:12:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753933AbYBESMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 13:12:43 -0500
Received: from relay1.sgi.com ([192.48.171.29]:54617 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751746AbYBESMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 13:12:42 -0500
Date: Tue, 5 Feb 2008 10:12:40 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
cc: Mel Gorman <mel@csn.ul.ie>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Paul Jackson <pj@sgi.com>, David Rientjes <rientjes@google.com>
Subject: Re: [2.6.24-rc8-mm1][regression?] numactl --interleave=all doesn't
 works on memoryless node.
In-Reply-To: <1202225017.5332.1.camel@localhost>
Message-ID: <Pine.LNX.4.64.0802051011400.11705@schroedinger.engr.sgi.com>
References: <20080202165054.F491.KOSAKI.MOTOHIRO@jp.fujitsu.com> 
 <20080202090914.GA27723@one.firstfloor.org>  <20080202180536.F494.KOSAKI.MOTOHIRO@jp.fujitsu.com>
  <1202149243.5028.61.camel@localhost>  <20080205143149.GA4207@csn.ul.ie>
 <1202225017.5332.1.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Could we focus on the problem instead of discussion of new patches under 
development? Can we confirm that what Kosaki sees is a bug?
