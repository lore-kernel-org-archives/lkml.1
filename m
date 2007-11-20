Return-Path: <linux-kernel-owner+w=401wt.eu-S1764476AbXKTWgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764476AbXKTWgu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 17:36:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760974AbXKTWgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 17:36:40 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34061
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751506AbXKTWgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 17:36:39 -0500
Date: Tue, 20 Nov 2007 14:36:38 -0800 (PST)
Message-Id: <20071120.143638.150132254.davem@davemloft.net>
To: zach.brown@oracle.com
Cc: drepper@redhat.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       torvalds@linux-foundation.org
Subject: Re: [PATCHv4 5/6] Allow setting O_NONBLOCK flag for new sockets
From: David Miller <davem@davemloft.net>
In-Reply-To: <474357EC.4080107@oracle.com>
References: <474305A5.7070100@redhat.com>
	<20071120.134839.229691661.davem@davemloft.net>
	<474357EC.4080107@oracle.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zach Brown <zach.brown@oracle.com>
Date: Tue, 20 Nov 2007 13:55:56 -0800

> Not to belabor this point, but it was:
> 
> http://lkml.org/lkml/2007/11/20/53
> 
> $ grep -l INDIRECT_PARAM .git/patches/master/*
> .git/patches/master/indirect-v4-4.patch
> .git/patches/master/indirect-v4-5.patch
> .git/patches/master/indirect-v4-6.patch
> 
> Maybe the patches got to you out of order so you saw 5/ before 4/?

Thanks for pointing this out, I stand corrected.
