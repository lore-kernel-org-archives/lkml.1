Return-Path: <linux-kernel-owner+w=401wt.eu-S1754020AbYLZJVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbYLZJVs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 04:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753449AbYLZJVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 04:21:37 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34045
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752966AbYLZJVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 04:21:36 -0500
Date: Fri, 26 Dec 2008 01:21:39 -0800 (PST)
Message-Id: <20081226.012139.229871700.davem@davemloft.net>
To: tilman@imap.cc
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] gigaset: use pr_err() and pr_info()
From: David Miller <davem@davemloft.net>
In-Reply-To: <200812230927.mBN9RG9k028586@mail.pxnet.com>
References: <20081223-patch-00.tilman@imap.cc>
	<200812230927.mBN9RG9k028586@mail.pxnet.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tilman Schmidt <tilman@imap.cc>
Date: Tue, 23 Dec 2008 10:27:16 +0100

> Switch from private printk wrapper macros to using pr_err() and
> pr_info() from linux/kernel.h, at the same time unifying a few
> error messages.
> 
> Signed-off-by: Tilman Schmidt <tilman@imap.cc>

Applied.
