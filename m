Return-Path: <linux-kernel-owner+w=401wt.eu-S1755404AbZEaF4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbZEaF4y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 01:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbZEaF4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 01:56:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40901
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752157AbZEaF4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 01:56:47 -0400
Date: Sat, 30 May 2009 22:56:46 -0700 (PDT)
Message-Id: <20090530.225646.109162435.davem@davemloft.net>
To: kyle@moffetthome.net
Cc: pavel@ucw.cz, yuan-bo.ye@motorola.com,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       jwboyer@linux.vnet.ibm.com, grant.likely@secretlab.ca, paulus@samba.org,
       rmk@arm.linux.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
From: David Miller <davem@davemloft.net>
In-Reply-To: <f73f7ab80905301829j45723fd6j6e04904c8214e3b9@mail.gmail.com>
References: <1243408083.13460.14.camel@debian-nb>
	<20090530112221.GA1395@ucw.cz>
	<f73f7ab80905301829j45723fd6j6e04904c8214e3b9@mail.gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyle Moffett <kyle@moffetthome.net>
Date: Sat, 30 May 2009 21:29:56 -0400

> On the other hand, since this is a new port, we can just assume that
> (for this port) we're going to fix the tools to use a different path.

I don't see any benefit from putting it somewhere else if existing
platforms already, especially wrt. reuse of existing tools and
bootup mount scripts.
