Return-Path: <linux-kernel-owner+w=401wt.eu-S1758129AbXINLQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129AbXINLQd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 07:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754651AbXINLQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 07:16:25 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47534 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305AbXINLQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 07:16:24 -0400
Subject: Re: [announce] CFS-devel, performance improvements
From: Peter Zijlstra <peterz@infradead.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>
In-Reply-To: <1189687469.21778.229.camel@twins>
References: <20070911200459.GA6974@elte.hu>
	 <Pine.LNX.4.64.0709121405130.1817@scrub.home>
	 <1189683320.21778.213.camel@twins>
	 <Pine.LNX.4.64.0709131354220.1817@scrub.home>
	 <1189687469.21778.229.camel@twins>
Content-Type: text/plain
Date: Fri, 14 Sep 2007 13:16:17 +0200
Message-Id: <1189768577.21778.281.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-13 at 14:44 +0200, Peter Zijlstra wrote:

> > If you look at the math, you'll see that I took the overflow into account, 
> > I even expected it. If you see this effect in my implementation, it would 
> > be a bug.
> 
> Ah, ok, I shall look to your patches in more detail, it was not obvious
> from the formulae you posted.

You indeed outlined it in your email, I must have forgotten it.
I have the attention span of a goldfish these days :-/

