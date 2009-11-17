Return-Path: <linux-kernel-owner+w=401wt.eu-S1753789AbZKQJWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789AbZKQJWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 04:22:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbZKQJWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 04:22:33 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33321
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752771AbZKQJWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 04:22:32 -0500
Date: Tue, 17 Nov 2009 01:22:48 -0800 (PST)
Message-Id: <20091117.012248.86306050.davem@davemloft.net>
To: huananhu@huawei.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       william.allen.simpson@gmail.com
Subject: Re: [PATCH 17/11]Optimize the upload speed for PPP connection.
From: David Miller <davem@davemloft.net>
In-Reply-To: <faf197be196ee.196eefaf197be@huawei.com>
References: <faf197be196ee.196eefaf197be@huawei.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: fangxiaozhi 00110321 <huananhu@huawei.com>
Date: Tue, 17 Nov 2009 17:19:02 +0800

> From: fangxiaozhi <huananhu@huawei.com>
> 1. This patch is based on the kernel of 2.6.32-rc4 
> 2. In this patch, we enlarge the out buffer size to optimize the upload speed for the ppp connection. Then it can support the upload of HSUPA data cards.
> Signed-off-by: fangxiaozhi <huananhu@huawei.com>

Your patch is broken, please don't wate my time like this.

+ git apply --check --whitespace=error-all diff
error: patch failed: drivers/net/ppp_async.c:36
error: drivers/net/ppp_async.c: patch does not apply
