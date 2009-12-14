Return-Path: <linux-kernel-owner+w=401wt.eu-S1757419AbZLNT03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419AbZLNT03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 14:26:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757102AbZLNT02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 14:26:28 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39879
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755555AbZLNT01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 14:26:27 -0500
Date: Mon, 14 Dec 2009 11:26:29 -0800 (PST)
Message-Id: <20091214.112629.147974749.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: john.dykstra1@gmail.com, lists@nerdbynature.de,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Badness at net/ipv4/inet_connection_sock.c:293
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B2690B4.3030604@gmail.com>
References: <20091214.111105.224947761.davem@davemloft.net>
	<20091214.111638.165984790.davem@davemloft.net>
	<4B2690B4.3030604@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 14 Dec 2009 20:23:32 +0100

> I wonder which workload triggers this...
> 
> If you disable syncookies, I presume you dont have warnings ?

Haven't tried, will do that.

All I do is receive email on this thing, but as you can
guess I'm a popular spam target, so lots of random sites.

