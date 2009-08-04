Return-Path: <linux-kernel-owner+w=401wt.eu-S932415AbZHDEXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415AbZHDEXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 00:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbZHDEXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 00:23:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38493
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751903AbZHDEXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 00:23:14 -0400
Date: Mon, 03 Aug 2009 21:23:23 -0700 (PDT)
Message-Id: <20090803.212323.256579233.davem@davemloft.net>
To: john.dykstra1@gmail.com
Cc: akpm@linux-foundation.org, chiachi@android.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: Keep interface binding when sending packets with
 ipi_ifindex = 0
From: David Miller <davem@davemloft.net>
In-Reply-To: <1248912621.13447.12.camel@merlyn>
References: <6c039e090907231439t1def08a4n10978733bee55bec@mail.gmail.com>
	<20090727144402.513369f1.akpm@linux-foundation.org>
	<1248912621.13447.12.camel@merlyn>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Dykstra <john.dykstra1@gmail.com>
Date: Wed, 29 Jul 2009 19:10:21 -0500

> I guess Dave's letting this stand.  I'm posting this just to make sure
> this is an explicit decision.

I'm still thinking about this.
