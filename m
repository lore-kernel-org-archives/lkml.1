Return-Path: <linux-kernel-owner+w=401wt.eu-S1756107AbZGUUBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107AbZGUUBs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 16:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756088AbZGUUBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 16:01:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41232
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756065AbZGUUBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 16:01:43 -0400
Date: Tue, 21 Jul 2009 13:01:49 -0700 (PDT)
Message-Id: <20090721.130149.71286172.davem@davemloft.net>
To: julia@diku.dk
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] drivers/net/mlx4: Adjust constant
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0907191809050.16542@ask.diku.dk>
References: <Pine.LNX.4.64.0907191809050.16542@ask.diku.dk>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Sun, 19 Jul 2009 18:09:25 +0200 (CEST)

> From: Julia Lawall <julia@diku.dk>
> 
> The values in the advertising field are typically ADVERTISED_xxx, not
> SUPPORTED_xxx.  Both SUPPORTED_10000baseT_Full and
> ADVERTISED_1000baseT_Full have the same value.
> 
> The semantic match that finds this problem is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
 ...
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied.
