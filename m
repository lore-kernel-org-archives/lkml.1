Return-Path: <linux-kernel-owner+w=401wt.eu-S1761261AbYEACUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761261AbYEACUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 22:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755026AbYEACRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 22:17:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33847
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757606AbYEACRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 22:17:52 -0400
Date: Wed, 30 Apr 2008 19:17:51 -0700 (PDT)
Message-Id: <20080430.191751.170120541.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: rjw@sisk.pl, w@1wt.eu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jirislaby@gmail.com
Subject: Re: Slow DOWN, please!!!
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.10.0804301855390.5994@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0804301831330.5994@woody.linux-foundation.org>
	<20080430.185142.219463829.davem@davemloft.net>
	<alpine.LFD.1.10.0804301855390.5994@woody.linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 30 Apr 2008 19:01:12 -0700 (PDT)

> I'm not saying we should merge crap.

That's exactly what's been happening this merge window though.

And throughout this, Andrew Morton has been the only person with the
balls and lack of ego problems to revert regression causing changes he
introduced.
