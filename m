Return-Path: <linux-kernel-owner+w=401wt.eu-S1757755AbXJ2RrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755AbXJ2RrP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 13:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752378AbXJ2RrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 13:47:00 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:42636 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981AbXJ2Rq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 13:46:59 -0400
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Paul Jackson <pj@sgi.com>
Cc: clameter@sgi.com, rientjes@google.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org, mel@csn.ul.ie
In-Reply-To: <20071029103316.a68d00be.pj@sgi.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
	 <alpine.DEB.0.9999.0710251541550.11929@chino.kir.corp.google.com>
	 <Pine.LNX.4.64.0710251635420.9635@schroedinger.engr.sgi.com>
	 <alpine.DEB.0.9999.0710251648430.23810@chino.kir.corp.google.com>
	 <Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com>
	 <20071025185506.8c373aa8.pj@sgi.com>
	 <alpine.DEB.0.9999.0710251900080.8024@chino.kir.corp.google.com>
	 <1193412644.5032.13.camel@localhost>
	 <alpine.DEB.0.9999.0710261145400.11674@chino.kir.corp.google.com>
	 <20071026120037.7b95a136.pj@sgi.com>
	 <alpine.DEB.0.9999.0710261344180.6249@chino.kir.corp.google.com>
	 <1193433239.5032.95.camel@localhost>
	 <Pine.LNX.4.64.0710261415580.18139@schroedinger.engr.sgi.com>
	 <1193433992.5032.102.camel@localhost>
	 <Pine.LNX.4.64.0710261436070.18899@schroedinger.engr.sgi.com>
	 <1193670056.5035.27.camel@localhost>  <20071029103316.a68d00be.pj@sgi.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Mon, 29 Oct 2007 13:46:40 -0400
Message-Id: <1193680000.5035.123.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-29 at 10:33 -0700, Paul Jackson wrote:
> Lee wrote:
> > I only brought it up again because now you all are considering another
> > nodemask per policy.
> 
> The patch David and I are discussing will replace the
> cpuset_mems_allowed nodemask in struct mempolicy, not
> add a new nodemask.  In other words, the meaning and
> name of that existing nodemask will change, with no
> change in the overall structure size.


Kool!

Lee

