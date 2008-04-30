Return-Path: <linux-kernel-owner+w=401wt.eu-S1758269AbYD3CED@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269AbYD3CED (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 22:04:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbYD3CDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 22:03:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41321
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750960AbYD3CDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 22:03:53 -0400
Date: Tue, 29 Apr 2008 19:03:52 -0700 (PDT)
Message-Id: <20080429.190352.137408408.davem@davemloft.net>
To: linux-kernel@vger.kernel.org
Subject: Slow DOWN, please!!!
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is starting to get beyond frustrating for me.

Yesterday, I spent the whole day bisecting boot failures
on my system due to the totally untested linux/bitops.h
optimization, which I fully analyzed and debugged.

Today, I had hoped that I could get some work done of my
own, but that's not the case.

Yet another bootup regression got added within the last 24
hours.

I don't mind fixing the regression or two during the merge
window but THIS IS ABSOLUTELY, FUCKING, REDICULIOUS!

The tree breaks every day, and it's becomming an extremely
non-fun environment to work in.

We need to slow down the merging, we need to review things
more, we need people to test their fucking changes!
