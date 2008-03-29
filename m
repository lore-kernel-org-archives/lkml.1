Return-Path: <linux-kernel-owner+w=401wt.eu-S1757962AbYC2Dyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962AbYC2Dyo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 23:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754923AbYC2Dye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 23:54:34 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41304 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558AbYC2Dye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 23:54:34 -0400
Date: Sat, 29 Mar 2008 03:54:31 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] jbd/jbd2 NULL noise
Message-ID: <20080329035431.GL10722@ZenIV.linux.org.uk>
References: <E1JfRPa-0002U9-J5@ZenIV.linux.org.uk> <1206760526.6543.0.camel@brick> <20080329031843.GJ10722@ZenIV.linux.org.uk> <1206761196.6543.2.camel@brick> <20080329034228.GK10722@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080329034228.GK10722@ZenIV.linux.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 29, 2008 at 03:42:28AM +0000, Al Viro wrote:

> > I did, it went into -mm and on Mar 5 it was taken into the subsystem
> > tree.
> 
> Wait a minute...  where had it been taken?  What subsystem tree for "just
> about all of fs/"?  

You've really got me curious.  The latest -mm I can find is 2.6.25-rc5-mm1,
it's dated Mar 11 and the patches are very much there -
broken-out/jbd-sparse-warnings-in-revokec-journalc.patch and
broken-out/jbd2-sparse-warnings-in-revokec-journalc.patch
resp., all by themselves and not as a part of any subsystem tree.

Linus, consider the patch upthread withdrawn.

Al, still morbidly curious about the akpm's scripts and aforementioned
message...
