Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886AbZKIEkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbZKIEkw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 23:40:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbZKIEkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 23:40:51 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38019
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751739AbZKIEku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 23:40:50 -0500
Date: Sun, 08 Nov 2009 20:41:16 -0800 (PST)
Message-Id: <20091108.204116.08930316.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: linux-next: net tree build failure
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091109132151.0e0ec7bc.sfr@canb.auug.org.au>
References: <20091109132151.0e0ec7bc.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 9 Nov 2009 13:21:51 +1100

> Subject: [PATCH] net/appletalk: using compat_ptr needs inclusion of linux/compat.h
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Applied, thanks Stephen.
