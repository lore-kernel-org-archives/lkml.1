Return-Path: <linux-kernel-owner+w=401wt.eu-S1758159AbYBRHsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159AbYBRHsx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 02:48:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756759AbYBRHsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 02:48:45 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40191 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097AbYBRHsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 02:48:43 -0500
Reply-To: <kmpark@infradead.org>
From: "Kyungmin Park" <kmpark@infradead.org>
To: "'Roel Kluin'" <12o3l@tiscali.nl>
Cc: <linux-mtd@lists.infradead.org>, "'lkml'" <linux-kernel@vger.kernel.org>
References: <47B719FB.4020107@tiscali.nl>
Subject: RE: [PATCH] drivers/mtd/onenand/onenand_base.c unlikely(x) || unlikely(y) => unlikely(x || y)
Date: Mon, 18 Feb 2008 16:48:52 +0900
Organization: infradead
Message-ID: <007701c87202$b87c8b10$1fa9580a@swcenter.sec.samsung.co.kr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-reply-to: <47B719FB.4020107@tiscali.nl>
X-MIMEOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Thread-index: Achwv2vRtPRypGT7S6q9VblxO6PxWABQr4Fw
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Not yet tested.
> ---
> Replace unlikely(x) || unlikely(y) by unlikely(x || y)
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Ack-by: Kyungmin Park <kyungmin.park@samsung.com>

