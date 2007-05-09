Return-Path: <linux-kernel-owner+w=401wt.eu-S1758596AbXEISr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758596AbXEISr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 14:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757442AbXEISrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 14:47:17 -0400
Received: from mail1.vetienne.net ([87.98.219.23]:1236 "EHLO
	mail1.vetienne.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756932AbXEISrQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 14:47:16 -0400
From: Vincent ETIENNE <ve@vetienne.net>
To: Jay Vosburgh <fubar@us.ibm.com>
Subject: Re: [Bonding-devel] [PROBLEM] Bonding driver in linux-2.6.21-rc6-mm1
Date: Wed, 9 May 2007 20:47:10 +0200
User-Agent: KMail/1.9.6
Cc: Chris Snook <csnook@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       bonding-devel@lists.sourceforge.net,
       "Andy Gospodarek" <andy@greyhouse.net>
References: <200704262058.33087.ve@vetienne.net> <46310B19.8@redhat.com> <1791.1177620299@death>
In-Reply-To: <1791.1177620299@death>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705092047.11753.ve@vetienne.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le Thursday 26 April 2007 22:44:59 Jay Vosburgh, vous avez écrit :
> Chris Snook <csnook@redhat.com> wrote:
> >Vincent ETIENNE wrote:
> >> Hi,
> >>
> >>  Summary :
> >> 	Got this trace when one network interface come down or up in a 2
> >> 	interfaces bonding.	So far, system seems to survive to this problem
> >> 	and works fine.
> >

> 	This problem looks to be one of the known locking issues with
> bonding.
>
> 	Andy Gospodarek <andy@greyhouse.net> and I have been working
> offline on the locking issues in bonding over the last several weeks.
> At the moment, we have a generally stable (but ugly with debug fluff and
> other yuckies) patch that seems to resolve at least the majority of the
> various issues.  I'm thinking to clean it up for general posting early
> next week, and address additional problems from there (since it's
> hopefully at least a big step forward).
>
> 	-J


Any news and/or patch concerning this problem ?. Not intended to stress you 
but time goes on... Do you think a solution could be found in a relatively 
short timeframe (and i will delay a bit final installation) or is it better 
to go without bonding and do an upgrade later ?.

	Vincent

>
> ---
> 	-Jay Vosburgh, IBM Linux Technology Center, fubar@us.ibm.com


