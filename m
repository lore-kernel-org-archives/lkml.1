Return-Path: <linux-kernel-owner+w=401wt.eu-S1758845AbYBES1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758845AbYBES1o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 13:27:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754324AbYBES1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 13:27:35 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:2313 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942AbYBES1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 13:27:34 -0500
Subject: Re: [2.6.24-rc8-mm1][regression?] numactl --interleave=all doesn't
	works on memoryless node.
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Mel Gorman <mel@csn.ul.ie>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Paul Jackson <pj@sgi.com>, David Rientjes <rientjes@google.com>
In-Reply-To: <Pine.LNX.4.64.0802051011400.11705@schroedinger.engr.sgi.com>
References: <20080202165054.F491.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080202090914.GA27723@one.firstfloor.org>
	 <20080202180536.F494.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <1202149243.5028.61.camel@localhost>  <20080205143149.GA4207@csn.ul.ie>
	 <1202225017.5332.1.camel@localhost>
	 <Pine.LNX.4.64.0802051011400.11705@schroedinger.engr.sgi.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Tue, 05 Feb 2008 13:27:35 -0500
Message-Id: <1202236056.5332.17.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-05 at 10:12 -0800, Christoph Lameter wrote:
> Could we focus on the problem instead of discussion of new patches under 
> development? 

Christoph:  you are free to ignore any part of this discussion that you
wish...

> Can we confirm that what Kosaki sees is a bug?

by definition, right?  we broke user space.  

Lee

