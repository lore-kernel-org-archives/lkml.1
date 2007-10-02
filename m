Return-Path: <linux-kernel-owner+w=401wt.eu-S1755398AbXJBRSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbXJBRSF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 13:18:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754820AbXJBRRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 13:17:46 -0400
Received: from atlrel8.hp.com ([156.153.255.206]:36592 "EHLO atlrel8.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396AbXJBRRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 13:17:45 -0400
Subject: Re: x86 patches was Re: -mm merge plans for 2.6.24
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       mpm@selenic.com, "Huang, Ying" <ying.huang@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Lameter <clameter@sgi.com>, apw@shadowen.org
In-Reply-To: <20071002163624.74534e7f.kamezawa.hiroyu@jp.fujitsu.com>
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
	 <p733awu6nva.fsf@bingen.suse.de>
	 <20071001233225.88c67e8b.akpm@linux-foundation.org>
	 <20071002070110.GA30490@one.firstfloor.org>
	 <20071002001809.0a814d0b.akpm@linux-foundation.org>
	 <20071002163624.74534e7f.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Tue, 02 Oct 2007 13:17:45 -0400
Message-Id: <1191345465.5026.0.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-02 at 16:36 +0900, KAMEZAWA Hiroyuki wrote:
> On Tue, 2 Oct 2007 00:18:09 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> > > 
> > > > How come?  Memoryless node can and do occur in real-world machines.  Kernel
> > > > should support that?
> > > 
> > > But a node is just defined by its memory? 
> > 
> > Don't think so.  A node is a lump of circuitry which can have zero or more
> > CPUs, IO and memory.
> > 
> > It may initially have been conceived as a memory-only concept in the Linux
> > kernel, but that doesn't fully map onto reality (does it?)
> > 
> > There was a real-world need for this, I think from the Fujitsu guys.  That
> > should be spelled out in the changelog but isn't.
> 
> Yes, Fujitsu and HP guys really need this memory-less-node support. 

Agreed!

Lee

