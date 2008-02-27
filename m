Return-Path: <linux-kernel-owner+w=401wt.eu-S932403AbYB0CZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403AbYB0CZT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 21:25:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763942AbYB0CZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 21:25:00 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59747
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1765444AbYB0CZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 21:25:00 -0500
Date: Tue, 26 Feb 2008 18:25:45 -0800 (PST)
Message-Id: <20080226.182545.55675767.davem@davemloft.net>
To: lizf@cn.fujitsu.com
Cc: johnpol@2ka.mipt.ru, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CONNECTOR: make cn_already_initialized static
From: David Miller <davem@davemloft.net>
In-Reply-To: <47C4C954.1090006@cn.fujitsu.com>
References: <47C4C954.1090006@cn.fujitsu.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>
Date: Wed, 27 Feb 2008 10:22:12 +0800

> It is used in connector.c only, so make it static.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Applied, thanks.
