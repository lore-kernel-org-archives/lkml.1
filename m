Return-Path: <linux-kernel-owner+w=401wt.eu-S1755976AbZKQMEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbZKQMEI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 07:04:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755504AbZKQMEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 07:04:08 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:40348 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978AbZKQMEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 07:04:07 -0500
Date: Tue, 17 Nov 2009 20:04:10 +0800
From: Franko Fang <huananhu@huawei.com>
Subject: Re: [PATCH 1/5]net: PPP buffer too small for higher speed connections
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       william.allen.simpson@gmail.com, jarkao2@gmail.com
Message-id: <00e801ca677e$122c8c10$76900b0a@china.huawei.com>
MIME-version: 1.0
X-MIMEOLE: Produced By Microsoft MimeOLE V6.00.2900.3350
X-Mailer: Microsoft Outlook Express 6.00.2900.3598
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
X-Priority: 3
X-MSMail-priority: Normal
References: <fb8cc3511cffa.1cffafb8cc351@huawei.com>
 <20091117.040234.245024359.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, that's great.

Thanks very much for your help.
----- Original Message ----- 
From: "David Miller" <davem@davemloft.net>
To: <huananhu@huawei.com>
Cc: <netdev@vger.kernel.org>; <linux-kernel@vger.kernel.org>; <william.allen.simpson@gmail.com>; <jarkao2@gmail.com>
Sent: Tuesday, November 17, 2009 8:02 PM
Subject: Re: [PATCH 1/5]net: PPP buffer too small for higher speed connections


> From: fangxiaozhi 00110321 <huananhu@huawei.com>
> Date: Tue, 17 Nov 2009 19:59:05 +0800
> 
>> From: fangxiaozhi <huananhu@huawei.com>
>> 1. This patch is based on the kernel of 2.6.32-rc7 
>> 2. In this patch, we enlarge the out buffer size to optimize the upload speed for the ppp connection. Then it can support the upload of HSUPA data cards.
>> Signed-off-by: fangxiaozhi <huananhu@huawei.com>
> 
> Applied to net-next-2.6, thanks.
