Return-Path: <linux-kernel-owner+w=401wt.eu-S1161306AbXEDR2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161306AbXEDR2m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 13:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161227AbXEDR2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 13:28:42 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:43988 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031439AbXEDR2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 13:28:41 -0400
Date: Fri, 4 May 2007 10:28:40 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH] change global zonelist order v4 [0/2]
In-Reply-To: <1178299460.5236.35.camel@localhost>
Message-ID: <Pine.LNX.4.64.0705041027030.22643@schroedinger.engr.sgi.com>
References: <20070427144530.ae42ee25.kamezawa.hiroyu@jp.fujitsu.com> 
 <20070503224730.3bc6f8a8.akpm@linux-foundation.org> 
 <200705040826.23687.jbarnes@virtuousgeek.org> 
 <Pine.LNX.4.64.0705040913340.21436@schroedinger.engr.sgi.com>
 <1178299460.5236.35.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 May 2007, Lee Schermerhorn wrote:

> Hmmm...  "serious hackery", indeed!  ;-)

Maybe on the arch level but minimal changes to core code.
And it is a step towards avoiding zones in NUMA.

