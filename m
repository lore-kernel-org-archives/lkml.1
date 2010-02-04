Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab0BDCoB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 21:44:01 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38320
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751809Ab0BDCn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 21:43:59 -0500
Date: Wed, 03 Feb 2010 18:44:12 -0800 (PST)
Message-Id: <20100203.184412.134604860.davem@davemloft.net>
To: joe@perches.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 07/10] drivers/net/amd8111e.c: Fix continuation line
 formats
From: David Miller <davem@davemloft.net>
In-Reply-To: <5f913ef7c2af30646e9c56eb4cb33a1d67d3a721.1264967500.git.joe@perches.com>
References: <cover.1264967493.git.joe@perches.com>
	<5f913ef7c2af30646e9c56eb4cb33a1d67d3a721.1264967500.git.joe@perches.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sun, 31 Jan 2010 12:02:09 -0800

> String constants that are continued on subsequent lines with \
> are not good.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, thanks.
