Return-Path: <linux-kernel-owner+w=401wt.eu-S1762682AbYDYPvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762682AbYDYPvx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 11:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753864AbYDYPvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 11:51:42 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:60989 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761714AbYDYPvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 11:51:41 -0400
Date: Fri, 25 Apr 2008 08:47:40 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       zdenek.kabelac@gmail.com, mingo@elte.hu, rjw@sisk.pl,
       paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
       herbert@gondor.apana.org.au, penberg@cs.helsinki.fi, clameter@sgi.com
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at
 ffffffffffffffff
Message-Id: <20080425084740.cab1cdf8.randy.dunlap@oracle.com>
In-Reply-To: <48118F85.4060703@gmail.com>
References: <48118B73.6000700@gmail.com>
	<20080425.004943.148536408.davem@davemloft.net>
	<48118EAB.5040004@gmail.com>
	<20080425.005816.249606540.davem@davemloft.net>
	<48118F85.4060703@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Apr 2008 10:00:05 +0200 Jiri Slaby wrote:

> On 04/25/2008 09:58 AM, David Miller wrote:
> >>> If so that could match up to the pattern.  It is just one theory
> >>> though.  The wireless possibility holds just as much weight.
> >> The mac80211 is theory too so far :).
> > 
> > I'll try to do some commit mining of my own.
> 
> BTW Doesn't exist any tool to compare diffs? Particularly 
> 2.6.28-rc8-mm1..2.6.28-rc8-mm2 with 2.6.25..2.6.25-git2... I would just give it 
> a try.

'interdiff', part of the patchutils package:
http://cyberelk.net/tim/software/patchutils/

---
~Randy
