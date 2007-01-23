Return-Path: <linux-kernel-owner+w=401wt.eu-S964928AbXAWNCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964928AbXAWNCm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 08:02:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964937AbXAWNCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 08:02:42 -0500
Received: from thccv19.oz.nthu.edu.tw ([140.114.63.219]:49680 "EHLO
	thccv19.oz.nthu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964928AbXAWNCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 08:02:41 -0500
From: "Yu-Chen Wu" <g944370@oz.nthu.edu.tw>
To: <linux-kernel@vger.kernel.org>
Subject: Could convert a buffer that allocated by vmalloc to pages?
Date: Tue, 23 Jan 2007 21:04:40 +0800
Message-ID: <030701c73eef$0b4d0010$0100a8c0@sslabmayasky>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Thread-Index: Acc+7wqoRNjJO2T+Ql6M6Ggq2sT05Q==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I write a driver have a big buffer (16MB,allocated by vmalloc).
I want to use the buffer to do DMA transmission so I need getting the pages
of the buffer.
Have any kernel API can do this?
My platform is x86_64 and 2GB RAM

THX

