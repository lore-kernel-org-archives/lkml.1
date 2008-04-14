Return-Path: <linux-kernel-owner+w=401wt.eu-S1755874AbYDNWBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874AbYDNWBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 18:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760536AbYDNWBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 18:01:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36103
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760177AbYDNWBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 18:01:04 -0400
Date: Mon, 14 Apr 2008 15:01:05 -0700 (PDT)
Message-Id: <20080414.150105.101568769.davem@davemloft.net>
To: jmorris@namei.org
Cc: viro@ZenIV.linux.org.uk, akpm@linux-foundation.org, w@1wt.eu,
       david@lang.hm, sclark46@earthlink.net, johnpol@2ka.mipt.ru, rjw@sisk.pl,
       tilman@imap.cc, Valdis.Kletnieks@vt.edu, lkml@rtr.ca,
       jesper.juhl@gmail.com, yoshfuji@linux-ipv6.org, jeff@garzik.org,
       linux-kernel@vger.kernel.org, git@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: Reporting bugs and bisection
From: David Miller <davem@davemloft.net>
In-Reply-To: <Xine.LNX.4.64.0804150131300.4160@us.intercode.com.au>
References: <20080413232441.e216a02c.akpm@linux-foundation.org>
	<20080414072328.GW9785@ZenIV.linux.org.uk>
	<Xine.LNX.4.64.0804150131300.4160@us.intercode.com.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Morris <jmorris@namei.org>
Date: Tue, 15 Apr 2008 01:54:00 +1000 (EST)

> - Things like "who made the kernel" statistics and related articles ignore 
>   code review.

Note the apparent irony in that the person who ends up often on the
top of those lists, Al Viro, is also someone who also does a
significant amount of code review.

I think this is no accident.
