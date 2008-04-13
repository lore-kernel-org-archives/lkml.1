Return-Path: <linux-kernel-owner+w=401wt.eu-S1759899AbYDMTxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759899AbYDMTxg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 15:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755071AbYDMTr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 15:47:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57358
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756599AbYDMTrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 15:47:25 -0400
Date: Sun, 13 Apr 2008 12:47:26 -0700 (PDT)
Message-Id: <20080413.124726.122432429.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: w@1wt.eu, rjw@sisk.pl, tilman@imap.cc, Valdis.Kletnieks@vt.edu,
       lkml@rtr.ca, jesper.juhl@gmail.com, yoshfuji@linux-ipv6.org,
       jeff@garzik.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Reporting bugs and bisection
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080413121831.d89dd424.akpm@linux-foundation.org>
References: <200804132040.12138.rjw@sisk.pl>
	<20080413184730.GD8474@1wt.eu>
	<20080413121831.d89dd424.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Sun, 13 Apr 2008 12:18:31 -0700

> That being said..  four or five years ago, developers would often work
> closely with the reporter working out why the reporter's failure was
> occurring.  Several days of back-and-forth.

The ratio of bug reports to developers was significantly different
back then.

I pine for the "good ole' days" of kernel development sometimes too,
but I try to be realistic and understand why things are different now.
