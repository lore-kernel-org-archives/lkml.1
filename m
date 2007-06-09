Return-Path: <linux-kernel-owner+w=401wt.eu-S969483AbXFICGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969483AbXFICGF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 22:06:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967932AbXFICFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 22:05:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50513
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S967864AbXFICFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 22:05:53 -0400
Date: Fri, 08 Jun 2007 19:06:08 -0700 (PDT)
Message-Id: <20070608.190608.117446027.davem@davemloft.net>
To: trond.myklebust@fys.uio.no
Cc: arekm@maven.pl, florin@iucha.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: networking busted in current -git ???
From: David Miller <davem@davemloft.net>
In-Reply-To: <1181339007.6675.12.camel@heimdal.trondhjem.org>
References: <20070608205640.GI30661@iucha.net>
	<200706082307.45722.arekm@maven.pl>
	<1181339007.6675.12.camel@heimdal.trondhjem.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trond Myklebust <trond.myklebust@fys.uio.no>
Date: Fri, 08 Jun 2007 17:43:27 -0400

> It is not dhcp. I'm seeing the same bug with bog-standard ifup with a
> static address on an FC-6 machine.
> 
> It appears to be something in the latest dump from davem to Linus, but I
> haven't yet had time to identify what.

Linus's current tree should have this fixed.

Let us know if this is not the case.
