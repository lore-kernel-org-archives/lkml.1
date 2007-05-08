Return-Path: <linux-kernel-owner+w=401wt.eu-S934543AbXEHRdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934543AbXEHRdy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 13:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934518AbXEHRdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 13:33:52 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:32906 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934510AbXEHRdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 13:33:51 -0400
Subject: Re: [PATCH] change zonelist order v5 [1/3] implements zonelist
	order selection
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, ak@suse.de, jbarnes@virtuousgeek.org
In-Reply-To: <Pine.LNX.4.64.0705081021340.9446@schroedinger.engr.sgi.com>
References: <20070508201401.8f78ec37.kamezawa.hiroyu@jp.fujitsu.com>
	 <20070508201642.c63b3f65.kamezawa.hiroyu@jp.fujitsu.com>
	 <1178643985.5203.27.camel@localhost>
	 <Pine.LNX.4.64.0705081021340.9446@schroedinger.engr.sgi.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Tue, 08 May 2007 13:33:41 -0400
Message-Id: <1178645622.5203.53.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-08 at 10:22 -0700, Christoph Lameter wrote:
> On Tue, 8 May 2007, Lee Schermerhorn wrote:
> 
> > > Signed-Off-By: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > Tested OK on my platform.
> > Acked-by:   Lee Schermerhorn <lee.schermerhorn@hp.com>
> 
> So far testing is IA64 only?

Yes, so far.  I will test on an Opteron platform this pm.  
Assume that no news is good news.

Lee

