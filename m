Return-Path: <linux-kernel-owner+w=401wt.eu-S1757560AbXGBM0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560AbXGBM0l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 08:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754630AbXGBM0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 08:26:31 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50989 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754416AbXGBM0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 08:26:30 -0400
Message-ID: <4688EEF3.2010305@pobox.com>
Date: Mon, 02 Jul 2007 08:26:27 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] drivers/net/ns83820.c: fix a check-after-use
References: <20070701202110.GH10869@stusta.de>
In-Reply-To: <20070701202110.GH10869@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch fixes a check-after-use spotted by the Coverity checker.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

applied


