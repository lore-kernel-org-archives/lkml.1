Return-Path: <linux-kernel-owner+w=401wt.eu-S1753246Ab0ADFny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab0ADFny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 00:43:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753150Ab0ADFnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 00:43:51 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51837
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753229Ab0ADFnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 00:43:40 -0500
Date: Sun, 03 Jan 2010 21:43:44 -0800 (PST)
Message-Id: <20100103.214344.55841020.davem@davemloft.net>
To: roel.kluin@gmail.com
Cc: netdev@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Test off by one in sh_eth_reset()
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B3B3CF1.6060107@gmail.com>
References: <4B3B3CF1.6060107@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <roel.kluin@gmail.com>
Date: Wed, 30 Dec 2009 12:43:45 +0100

> If no break occurred, cnt reaches 0 after the loop.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Applied.
