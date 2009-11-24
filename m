Return-Path: <linux-kernel-owner+w=401wt.eu-S1757999AbZKXGyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999AbZKXGyN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 01:54:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756720AbZKXGyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 01:54:12 -0500
Received: from cantor.suse.de ([195.135.220.2]:51029 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754114AbZKXGyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 01:54:12 -0500
Date: Tue, 24 Nov 2009 07:54:17 +0100
From: Nick Piggin <npiggin@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: newidle balancing in NUMA domain?
Message-ID: <20091124065417.GD20981@wotan.suse.de>
References: <20091123112228.GA2287@wotan.suse.de> <1258987059.6193.73.camel@marge.simson.net> <20091123151152.GA19175@wotan.suse.de> <1258989704.4531.574.camel@laptop> <20091123152931.GD19175@wotan.suse.de> <1258990647.4531.600.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258990647.4531.600.camel@laptop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 04:37:27PM +0100, Peter Zijlstra wrote:
> On Mon, 2009-11-23 at 16:29 +0100, Nick Piggin wrote:
> > 
> > > .32 is kind of closed, with us being at -rc8.
> > 
> > It's a bad regression though.
> 
> Still haven't heard what workload, what machine, by how-much, nor any
> reproducer.

http://patchwork.kernel.org/patch/58931/

 
> And again, -rc8 is really late.

Exactly the right time to sort out regressions, however.

