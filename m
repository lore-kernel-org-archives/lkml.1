Return-Path: <linux-kernel-owner+w=401wt.eu-S1764912AbXHXSJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764912AbXHXSJB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 14:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765814AbXHXSIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 14:08:36 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:32850 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764962AbXHXSIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 14:08:34 -0400
Date: Fri, 24 Aug 2007 11:08:33 -0700 (PDT)
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
In-Reply-To: <1187978585.5869.34.camel@localhost>
Message-ID: <Pine.LNX.4.64.0708241107330.22511@schroedinger.engr.sgi.com>
References: <617E1C2C70743745A92448908E030B2A023EB020@scsmsx411.amr.corp.intel.com>
  <20070823142133.9359a1ce.akpm@linux-foundation.org> 
 <20070824153945.3C75.Y-GOTO@jp.fujitsu.com>  <20070824145233.GA26374@skynet.ie>
 <1187970572.5869.10.camel@localhost>  <Pine.LNX.4.64.0708240957010.20501@schroedinger.engr.sgi.com>
 <1187978585.5869.34.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2007, Lee Schermerhorn wrote:

> PATCH Diffs between "Fix generic usage of node_online_map" V1 & V2

Ahh. Yes. I remember some of that.

Acked-by: Christoph Lameter <clameter@sgi.com>

