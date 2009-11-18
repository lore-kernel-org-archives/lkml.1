Return-Path: <linux-kernel-owner+w=401wt.eu-S932514AbZKRSxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514AbZKRSxL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 13:53:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932451AbZKRSvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 13:51:37 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58158
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758276AbZKRSvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 13:51:35 -0500
Date: Wed, 18 Nov 2009 10:51:52 -0800 (PST)
Message-Id: <20091118.105152.188789288.davem@davemloft.net>
To: julia@diku.dk
Cc: romieu@fr.zoreil.com, netdev@vger.kernel.org, arnd@arndb.de,
       joe@perches.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 11/16] drivers/net/via-velocity.c: remove exceptional &
 on function name
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0911181923540.20943@ask.diku.dk>
References: <Pine.LNX.4.64.0911181923540.20943@ask.diku.dk>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Wed, 18 Nov 2009 19:24:13 +0100 (CET)

> In this file, function names are otherwise used as pointers without &.
  ...
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied.
