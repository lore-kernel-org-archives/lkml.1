Return-Path: <linux-kernel-owner+w=401wt.eu-S1756618AbYLMFSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618AbYLMFSt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 00:18:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbYLMFSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 00:18:41 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42652
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751363AbYLMFSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 00:18:40 -0500
Date: Fri, 12 Dec 2008 21:18:41 -0800 (PST)
Message-Id: <20081212.211841.94747482.davem@davemloft.net>
To: hannes@hanneseder.net
Cc: netdev@vger.kernel.org, kkeil@suse.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 7/9][v2] mISDN: comment out unused symbols
From: David Miller <davem@davemloft.net>
In-Reply-To: <49419a3b.0aec660a.2b49.7900@mx.google.com>
References: <49419a3b.0aec660a.2b49.7900@mx.google.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>
Date: Thu, 11 Dec 2008 22:36:00 +0100

> Fix this sparse warnings:
> 
>   drivers/isdn/hardware/mISDN/hfcmulti.c:794: warning: 'vpm_check' defined but not used
>   drivers/isdn/mISDN/dsp_cmx.c:1546: warning: 'dsp_start_jiffies' defined but not used
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> Acked-by: Karsten Keil <kkeil@suse.de>

Applied.
