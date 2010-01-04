Return-Path: <linux-kernel-owner+w=401wt.eu-S1753261Ab0ADFo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab0ADFo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 00:44:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203Ab0ADFoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 00:44:23 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51846
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753157Ab0ADFoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 00:44:20 -0500
Date: Sun, 03 Jan 2010 21:44:24 -0800 (PST)
Message-Id: <20100103.214424.144353990.davem@davemloft.net>
To: error27@gmail.com
Cc: jarkao2@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] hamradio: avoid null deref v3
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091228165455.GA17645@bicker>
References: <20091226123812.GB6075@bicker>
	<20091226.201729.15225529.davem@davemloft.net>
	<20091228165455.GA17645@bicker>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>
Date: Mon, 28 Dec 2009 18:54:55 +0200

> This should address the problems in version 1 (lazy) and version 2 (ugly).
> 
> Bump the stats on orig_dev not on the newly assigned NULL dev variable.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Applied.
