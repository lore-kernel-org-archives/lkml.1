Return-Path: <linux-kernel-owner+w=401wt.eu-S1761889AbXJYHck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761889AbXJYHck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 03:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758037AbXJYHbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 03:31:52 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58938 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757714AbXJYHbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 03:31:51 -0400
Message-ID: <47204657.3080701@pobox.com>
Date: Thu, 25 Oct 2007 03:31:35 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Jesse Huang <jesse@icplus.com.tw>, Stefan Lippers-Hollmann <s.l-h@gmx.de>,
       Francois Romieu <romieu@fr.zoreil.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] drivers/net/ipg.c: cleanups
References: <20071024162319.GL30533@stusta.de>
In-Reply-To: <20071024162319.GL30533@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch contains the following cleanups:
> - make ipg_nic_get_stats() static
> - move DefaultPhyParam[] from ipg.h to ipg.c and make it static
> 

applied


