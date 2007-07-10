Return-Path: <linux-kernel-owner+w=401wt.eu-S1763488AbXGJJEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763488AbXGJJEN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 05:04:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756852AbXGJJD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 05:03:56 -0400
Received: from waste.org ([66.93.16.53]:54948 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756244AbXGJJDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 05:03:55 -0400
Date: Tue, 10 Jul 2007 04:02:45 -0500
From: Matt Mackall <mpm@selenic.com>
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Keiichi Kii <k-keiichi@bx.jp.nec.com>, Netdev <netdev@vger.kernel.org>,
       Joel Becker <joel.becker@oracle.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2 -mm 1/9] netconsole: Cleanups, codingstyle, prettyfication
Message-ID: <20070710090245.GJ11115@waste.org>
References: <20070710091920.23907.96483.sendpatchset@cselinux1.cse.iitk.ac.in> <20070710091925.23907.3312.sendpatchset@cselinux1.cse.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070710091925.23907.3312.sendpatchset@cselinux1.cse.iitk.ac.in>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 02:49:25PM +0530, Satyam Sharma wrote:
> From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
> 
> [1/9] netconsole: Cleanups, codingstyle, prettyfication
> 
> (1) Remove unwanted headers.
> (2) Mark __init and __exit as appropriate.
> (3) Various trivial codingstyle and prettification stuff.

I don't much like what you've done in (3) because I personally think
tabs should never appear anywhere but at the beginning of a line.
Which is why we consistently ask for people not to mix codingstyle
bits with substantive changes.

But what the hell..

Acked-by: Matt Mackall <mpm@selenic.com>

-- 
Mathematics is the supreme nostalgia of our time.
