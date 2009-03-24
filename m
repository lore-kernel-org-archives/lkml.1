Return-Path: <linux-kernel-owner+w=401wt.eu-S1762259AbZCXTnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762259AbZCXTnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 15:43:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756659AbZCXTm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 15:42:56 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52153
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757427AbZCXTmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 15:42:55 -0400
Date: Tue, 24 Mar 2009 12:42:42 -0700 (PDT)
Message-Id: <20090324.124242.84651080.davem@davemloft.net>
To: sinter.salt@gmx.de
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: BUG in 2.6.29 final: broken network connection
From: David Miller <davem@davemloft.net>
In-Reply-To: <200903241918.29929.sinter.salt@gmx.de>
References: <200903241812.14577.sinter.salt@gmx.de>
	<20090324172503.1627a3ef@lxorguk.ukuu.org.uk>
	<200903241918.29929.sinter.salt@gmx.de>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: sinter <sinter.salt@gmx.de>
Date: Tue, 24 Mar 2009 19:18:29 +0100

> Who needs a maintainer adding his SOB with closed eyes under untested crap 
> code? Who needs someone like that for kernel development?

Hey Uwe, nothing interesting going on in your life so you have to make
other people miserable?

This patch was tested, and it made a bug reporter's kernel crash go
away.

We'll fix the problems we're seeing now, just like we always do.
