Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523Ab0CGX1x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 18:27:53 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50941
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751421Ab0CGX1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 18:27:50 -0500
Date: Sun, 07 Mar 2010 15:28:10 -0800 (PST)
Message-Id: <20100307.152810.247228037.davem@davemloft.net>
To: error27@gmail.com
Cc: netdev@vger.kernel.org, eric.dumazet@gmail.com, jengelh@medozas.de,
       mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [patch] sock.c: potential null dereference
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100306110445.GC4958@bicker>
References: <20100306110445.GC4958@bicker>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>
Date: Sat, 6 Mar 2010 14:04:45 +0300

> We test that "prot->rsk_prot" is non-null right before we dereference it
> on this line.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Applied.
