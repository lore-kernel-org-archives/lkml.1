Return-Path: <linux-kernel-owner+w=401wt.eu-S932219AbXHYGZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219AbXHYGZS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 02:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755239AbXHYGZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 02:25:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43923
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754646AbXHYGZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 02:25:02 -0400
Date: Fri, 24 Aug 2007 23:25:01 -0700 (PDT)
Message-Id: <20070824.232501.08140344.davem@davemloft.net>
To: jesper.juhl@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 16/30] net: Avoid pointless allocation casts in BSD
 compression module
From: David Miller <davem@davemloft.net>
In-Reply-To: <fd58f69b12c07872b351261199f3c677c6786f06.1187912217.git.jesper.juhl@gmail.com>
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
	<fd58f69b12c07872b351261199f3c677c6786f06.1187912217.git.jesper.juhl@gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jesper.juhl@gmail.com>
Date: Fri, 24 Aug 2007 02:06:58 +0200

> The general kernel memory allocation functions return void pointers
> and there is no need to cast their return values.
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>

Applied.
