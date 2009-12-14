Return-Path: <linux-kernel-owner+w=401wt.eu-S932487AbZLNTQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932487AbZLNTQi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 14:16:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932458AbZLNTQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 14:16:37 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59006
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932431AbZLNTQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 14:16:36 -0500
Date: Mon, 14 Dec 2009 11:16:38 -0800 (PST)
Message-Id: <20091214.111638.165984790.davem@davemloft.net>
To: john.dykstra1@gmail.com
Cc: eric.dumazet@gmail.com, lists@nerdbynature.de,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Badness at net/ipv4/inet_connection_sock.c:293
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091214.111105.224947761.davem@davemloft.net>
References: <4B267708.3010202@gmail.com>
	<1260817033.9141.8.camel@merlyn>
	<20091214.111105.224947761.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Mon, 14 Dec 2009 11:11:05 -0800 (PST)

> I usually see 2 or 3 three of these bug triggers in the first ten
> minutes after bootup and I haven't seen one yet in 20 minutes
> with the commit reverted.

Nevermind, I take that back, I just got two triggers :-/
