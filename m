Return-Path: <linux-kernel-owner+w=401wt.eu-S1758224AbYDZRlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224AbYDZRlo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 13:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbYDZRlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 13:41:36 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:55714 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbYDZRlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 13:41:36 -0400
Date: Sat, 26 Apr 2008 19:42:08 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: If you want me to quit I will quit
Message-ID: <20080426174208.GC29451@uranus.ravnborg.org>
References: <1209190455.14173.13.camel@brick> <20080426110044.GB2252@cs181133002.pp.htv.fi> <20080426075132.b0fdbe13.akpm@linux-foundation.org> <20080426152341.GI2252@cs181133002.pp.htv.fi> <20080426084420.8e61c379.akpm@linux-foundation.org> <20080426171604.GN2252@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804261024580.2813@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804261024580.2813@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Because if it becomes normal coding practice, now people cannot work with 
> you sanely any more (ie some random person pulls your tree for testing, 
> and then I pull it at some other time, and the tester reports a problem, 
> but now the commits he is talking about don't actually even exist in my 
> tree any more, and it's all really messy!).

It also depends on whare you are located in the dependency tree.
Being kbuidl maintainer I have very few people that actually
pull me git tree (except from -mm and -next).
So I rebase at will and have so far not got a single complaint
from anyone pulling my tree.

But people like Davem and Ingo sits much higher in the dependency chain
and thus they have a very different set of users and thus a different
set of problems to take into account.

	Sam
