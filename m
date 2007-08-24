Return-Path: <linux-kernel-owner+w=401wt.eu-S1762654AbXHXRBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762654AbXHXRBJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 13:01:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755399AbXHXRAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 13:00:54 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:48860 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761468AbXHXRAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 13:00:38 -0400
Date: Fri, 24 Aug 2007 10:00:35 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
cc: Mel Gorman <mel@skynet.ie>, Yasunori Goto <y-goto@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       "Luck, Tony" <tony.luck@intel.com>, Jeremy Higdon <jeremy@sgi.com>,
       Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-ia64@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] Fix find_next_best_node (Re: [BUG] 2.6.23-rc3-mm1 Kernel
 panic - not syncing: DMA: Memory would be corrupted)
In-Reply-To: <1187970572.5869.10.camel@localhost>
Message-ID: <Pine.LNX.4.64.0708240957010.20501@schroedinger.engr.sgi.com>
References: <617E1C2C70743745A92448908E030B2A023EB020@scsmsx411.amr.corp.intel.com>
  <20070823142133.9359a1ce.akpm@linux-foundation.org> 
 <20070824153945.3C75.Y-GOTO@jp.fujitsu.com>  <20070824145233.GA26374@skynet.ie>
 <1187970572.5869.10.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2007, Lee Schermerhorn wrote:

> I reworked that patch and posted the update on 16aug which does not have
> this problem:
> 
> http://marc.info/?l=linux-mm&m=118729871101418&w=4
> 
> This should replace
> memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code.patch
> in -mm.

Could you post a diff to rc3-mm1 of that patch?

