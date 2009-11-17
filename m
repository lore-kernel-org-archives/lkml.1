Return-Path: <linux-kernel-owner+w=401wt.eu-S1755672AbZKQMCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672AbZKQMCT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 07:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754970AbZKQMCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 07:02:18 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41458
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754789AbZKQMCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 07:02:18 -0500
Date: Tue, 17 Nov 2009 04:02:34 -0800 (PST)
Message-Id: <20091117.040234.245024359.davem@davemloft.net>
To: huananhu@huawei.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       william.allen.simpson@gmail.com, jarkao2@gmail.com
Subject: Re: [PATCH 1/5]net: PPP buffer too small for higher speed
 connections
From: David Miller <davem@davemloft.net>
In-Reply-To: <fb8cc3511cffa.1cffafb8cc351@huawei.com>
References: <fb8cc3511cffa.1cffafb8cc351@huawei.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: fangxiaozhi 00110321 <huananhu@huawei.com>
Date: Tue, 17 Nov 2009 19:59:05 +0800

> From: fangxiaozhi <huananhu@huawei.com>
> 1. This patch is based on the kernel of 2.6.32-rc7 
> 2. In this patch, we enlarge the out buffer size to optimize the upload speed for the ppp connection. Then it can support the upload of HSUPA data cards.
> Signed-off-by: fangxiaozhi <huananhu@huawei.com>

Applied to net-next-2.6, thanks.
