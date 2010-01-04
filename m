Return-Path: <linux-kernel-owner+w=401wt.eu-S1753001Ab0ADFWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab0ADFWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 00:22:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711Ab0ADFWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 00:22:47 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51926
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752033Ab0ADFWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 00:22:46 -0500
Date: Sun, 03 Jan 2010 21:22:49 -0800 (PST)
Message-Id: <20100103.212249.91319016.davem@davemloft.net>
To: divy@chelsio.com
Cc: julia@diku.dk, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/7] drivers/net/cxgb3: Use kzalloc for allocating only
 one thing
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B3005D5.9070608@chelsio.com>
References: <Pine.LNX.4.64.0912190816340.30546@ask.diku.dk>
	<4B3005D5.9070608@chelsio.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>
Date: Mon, 21 Dec 2009 15:33:41 -0800

> Julia Lawall wrote:
>>
>> From: Julia Lawall <julia@diku.dk>
>>
>> Use kzalloc rather than kcalloc(1,...)
 ...
>> Signed-off-by: Julia Lawall <julia@diku.dk>
>>
> 
> Acked-by: Divy Le Ray <divy@chelsio.com>

Applied to net-next-2.6, thanks.
