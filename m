Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbZGUUB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbZGUUB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 16:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756011AbZGUUB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 16:01:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41229
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755681AbZGUUB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 16:01:27 -0400
Date: Tue, 21 Jul 2009 13:01:32 -0700 (PDT)
Message-Id: <20090721.130132.152098027.davem@davemloft.net>
To: julia@diku.dk
Cc: eilong@broadcom.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 4/10] drivers/net: Move a dereference below a NULL test
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0907191726140.16542@ask.diku.dk>
References: <Pine.LNX.4.64.0907191726140.16542@ask.diku.dk>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Sun, 19 Jul 2009 17:26:35 +0200 (CEST)

> From: Julia Lawall <julia@diku.dk>
> 
> If the NULL test is necessary, then the dereference should be moved below
> the NULL test.
> 
> The semantic patch that makes this change is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
 ...
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied.
