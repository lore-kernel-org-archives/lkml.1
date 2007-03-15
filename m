Return-Path: <linux-kernel-owner+w=401wt.eu-S1030603AbXCORBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030603AbXCORBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 13:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030649AbXCORBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 13:01:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48864 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030603AbXCORBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 13:01:15 -0400
Date: Thu, 15 Mar 2007 18:01:12 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Bligh <mbligh@mbligh.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 - Take 2
Message-ID: <20070315170112.GA14759@one.firstfloor.org>
References: <20070314050819.536207642@goodmis.org> <p73slc8863r.fsf@bingen.suse.de> <20070314125330.GA13168@elte.hu> <Pine.LNX.4.64.0703140850250.9690@woody.linux-foundation.org> <45F96B57.10206@mbligh.org> <Pine.LNX.4.64.0703150858040.3816@woody.linux-foundation.org> <20070315160648.GA11812@one.firstfloor.org> <1173977264.7922.24.camel@localhost.localdomain> <1173977839.7922.27.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173977839.7922.27.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Oops, sorry, you did say "in the includes".  Yeah, that holds the same
> crap that I'm talking about. 

It's a simple and obvious solution that does exactly what it is 
supposed to do. Why do you call it crap? 

-Andi
