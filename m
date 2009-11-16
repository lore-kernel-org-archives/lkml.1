Return-Path: <linux-kernel-owner+w=401wt.eu-S1752131AbZKPFSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbZKPFSF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 00:18:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038AbZKPFSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 00:18:04 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43613
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751676AbZKPFSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 00:18:03 -0500
Date: Sun, 15 Nov 2009 21:18:19 -0800 (PST)
Message-Id: <20091115.211819.244743978.davem@davemloft.net>
To: keil@b1-systems.de
Cc: roel.kluin@gmail.com, isdn4linux@listserv.isdn4linux.de,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mISDN: fix error return in HFCmulti_init()
From: David Miller <davem@davemloft.net>
In-Reply-To: <200911131317.10446.keil@b1-systems.de>
References: <4AFC3D85.6070904@gmail.com>
	<200911131317.10446.keil@b1-systems.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Karsten Keil <keil@b1-systems.de>
Date: Fri, 13 Nov 2009 13:17:10 +0100

> On Donnerstag, 12. November 2009 17:53:25 Roel Kluin wrote:
>  The returned error should stay negative
>  
>  Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> Acked-by: Karsten Keil <keil@b1-systems.de>

Applied.
