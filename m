Return-Path: <linux-kernel-owner+w=401wt.eu-S1753252Ab0ADFoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab0ADFoQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 00:44:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203Ab0ADFoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 00:44:11 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51842
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750824Ab0ADFoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 00:44:08 -0500
Date: Sun, 03 Jan 2010 21:44:12 -0800 (PST)
Message-Id: <20100103.214412.50599561.davem@davemloft.net>
To: julia@diku.dk
Cc: urs.thuermann@volkswagen.de, oliver.hartkopp@volkswagen.de,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 4/5] drivers/net/can: Correct NULL test
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0912272227290.20548@ask.diku.dk>
References: <Pine.LNX.4.64.0912272227290.20548@ask.diku.dk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Sun, 27 Dec 2009 22:27:44 +0100 (CET)

> From: Julia Lawall <julia@diku.dk>
> 
> Test the just-allocated value for NULL rather than some other value.
 ...
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied.
