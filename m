Return-Path: <linux-kernel-owner+w=401wt.eu-S965855AbXCFLUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965855AbXCFLUv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 06:20:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965852AbXCFLUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 06:20:51 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:53341 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934082AbXCFLUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 06:20:21 -0500
Message-ID: <45ED4E71.4080106@garzik.org>
Date: Tue, 06 Mar 2007 06:20:17 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: linux-driver@qlogic.com, Ron Mercer <ron.mercer@qlogic.com>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] drivers/net/qla3xxx.c: make 2 functions static
References: <20070305014927.GY3441@stusta.de>
In-Reply-To: <20070305014927.GY3441@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch makes two needlessly global functions static.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

applied


