Return-Path: <linux-kernel-owner+w=401wt.eu-S1756678AbXFTXP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678AbXFTXP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 19:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752494AbXFTXPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 19:15:18 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:45618 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039AbXFTXPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 19:15:17 -0400
Message-ID: <4679B503.1030106@garzik.org>
Date: Wed, 20 Jun 2007 19:15:15 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] natsemi irq flags
References: <20070615211608.11079.35368.stgit@ghaskins-t60p.haskins.net>
In-Reply-To: <20070615211608.11079.35368.stgit@ghaskins-t60p.haskins.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> The spinlock irq flags should be a unsigned long to properly support 64 bit
> 
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> 
> ---
> 
>  drivers/net/natsemi.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

applied to #upstream-fixes


