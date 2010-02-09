Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633Ab0BIGoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 01:44:46 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59492
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752681Ab0BIGop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 01:44:45 -0500
Date: Mon, 08 Feb 2010 22:44:59 -0800 (PST)
Message-Id: <20100208.224459.02579519.davem@davemloft.net>
To: julia@diku.dk
Cc: p_gortmaker@yahoo.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 8/11] drivers/net: Correct NULL test
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.1002060943580.8092@ask.diku.dk>
References: <Pine.LNX.4.64.1002060943580.8092@ask.diku.dk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Sat, 6 Feb 2010 09:44:15 +0100 (CET)

> From: Julia Lawall <julia@diku.dk>
> 
> Test the value that was just allocated rather than the previously tested one.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)

Hehe, every time I read that tool name I hear "Coco Channel" :-)

> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied, thanks!
