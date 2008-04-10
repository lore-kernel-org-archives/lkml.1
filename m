Return-Path: <linux-kernel-owner+w=401wt.eu-S1758229AbYDJXPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229AbYDJXPG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 19:15:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752910AbYDJXOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 19:14:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39850
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752693AbYDJXOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 19:14:52 -0400
Date: Thu, 10 Apr 2008 16:14:53 -0700 (PDT)
Message-Id: <20080410.161453.52032573.davem@davemloft.net>
To: vincent-perrier@club-internet.fr
Cc: jesper.juhl@gmail.com, tilman@imap.cc, lkml@rtr.ca,
       yoshfuji@linux-ipv6.org, jeff@garzik.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, linux-net@vger.kernel.org
Subject: Re: 2.6.25-rc8: FTP transfer errors
From: David Miller <davem@davemloft.net>
In-Reply-To: <1207869029.19683.13.camel@localhost>
References: <9a8748490804101509l5d043ff8w565dc44dfeaf0072@mail.gmail.com>
	<20080410.154651.101700010.davem@davemloft.net>
	<1207869029.19683.13.camel@localhost>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: vincent-perrier <vincent-perrier@club-internet.fr>
Date: Fri, 11 Apr 2008 01:10:29 +0200

> I am an end user, I do not know precisely what bisecting means, but I
> have spent some time on bug 8895, I suppose I have totally bisseced it,
> but it seems that it has been lost. 
> It is clearly a bug and I am still patching every kernel to avoid the 
> fib6 crash, obviously I am the only one to get it.

I remember this bug.

The analysis is incorrect and the patch adds new errors.
