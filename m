Return-Path: <linux-kernel-owner+w=401wt.eu-S1758270AbZKRStL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270AbZKRStL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 13:49:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756133AbZKRStF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 13:49:05 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58112
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755977AbZKRStC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 13:49:02 -0500
Date: Wed, 18 Nov 2009 10:49:18 -0800 (PST)
Message-Id: <20091118.104918.258152188.davem@davemloft.net>
To: julia@diku.dk
Cc: romieu@fr.zoreil.com, sorbica@icplus.com.tw, jesse@icplus.com.tw,
       netdev@vger.kernel.org, arnd@arndb.de, joe@perches.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 4/16] drivers/net/ipg.c: remove exceptional & on
 function name
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0911181921050.20943@ask.diku.dk>
References: <Pine.LNX.4.64.0911181921050.20943@ask.diku.dk>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Wed, 18 Nov 2009 19:21:45 +0100 (CET)

> In this file, function names are otherwise used as pointers without &.
...
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied.
