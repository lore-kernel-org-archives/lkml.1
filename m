Return-Path: <linux-kernel-owner+w=401wt.eu-S1756905AbZLEWVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905AbZLEWVZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 17:21:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755614AbZLEWVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 17:21:20 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39392
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755132AbZLEWVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 17:21:19 -0500
Date: Sat, 05 Dec 2009 14:21:26 -0800 (PST)
Message-Id: <20091205.142126.23618243.davem@davemloft.net>
To: william.allen.simpson@gmail.com
Cc: joe@perches.com, brice@myri.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next-2.6] drivers/net: Move && and || to end of
 previous line
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B1A557D.4080707@gmail.com>
References: <4B190A29.5080905@myri.com>
	<1259947271.22783.120.camel@Joe-Laptop.home>
	<4B1A557D.4080707@gmail.com>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: William Allen Simpson <william.allen.simpson@gmail.com>
Date: Sat, 05 Dec 2009 07:43:41 -0500

> These patches should not be accepted to the main Linus tree.

You come out of nowhere as a new contributor.  You have to constantly
ask about policy and other formalities wrt. kernel development.

Yet here you are telling us what should or should not go into the
tree.

You don't even know what the "merge window" is yet you seem so
confident to elicit firm declarations about code policy.

That's nothing but blind arrogance.

Nobody can take you seriously William, really.

And if you think just omitting Joe's patch is going to make your
backporting work any easier, you're mistaken.

Every release we make tons and tons of cleanups and refactorizations
all over the networking and sometimes heavily in TCP.  So you're going
to run into such problems no matter whether Joe's patch goes in or
not.

And like Joe, I think you overstate  how much effort is involved
in such work.  Especially for the size of your patch.

And consider, how in the world do you think it is for me to have to
handle hundreds of patches per day from random people.  If anyone
should get the brunt of the pain, it's me.

Yet I'm ok with it, and you should be too.
