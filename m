Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031835Ab0B1Lb1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 06:31:27 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59314
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031801Ab0B1LbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 06:31:25 -0500
Date: Sun, 28 Feb 2010 03:31:41 -0800 (PST)
Message-Id: <20100228.033141.233690283.davem@davemloft.net>
To: akinobu.mita@gmail.com
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH] sparc: use __ratelimit
From: David Miller <davem@davemloft.net>
In-Reply-To: <1267354697-6456-5-git-send-email-akinobu.mita@gmail.com>
References: <1267354697-6456-1-git-send-email-akinobu.mita@gmail.com>
	<1267354697-6456-5-git-send-email-akinobu.mita@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Sun, 28 Feb 2010 19:58:17 +0900

> Replace open-coded rate limiting logic with __ratelimit().
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

Applied, thanks.
