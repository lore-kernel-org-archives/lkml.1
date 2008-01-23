Return-Path: <linux-kernel-owner+w=401wt.eu-S1752424AbYAWJ7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424AbYAWJ7e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 04:59:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751375AbYAWJ7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 04:59:24 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:47157 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135AbYAWJ7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 04:59:23 -0500
Message-ID: <47970FF9.7010009@garzik.org>
Date: Wed, 23 Jan 2008 04:59:21 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jike Song <albcamus@gmail.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pci-skeleton: Misc fixes to build neatly
References: <df9815e70801212216v79ff8137kccc6a94ddb96c818@mail.gmail.com>
In-Reply-To: <df9815e70801212216v79ff8137kccc6a94ddb96c818@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jike Song wrote:
> Hello Jeff,
> 
> The pci-skeleton.c has several problems with compilation, such as missing args
> when calling synchronize_irq(). Fix it.
> 
> Signed-off-by: Jike Song <albcamus@gmail.com>
> ---
>  drivers/net/pci-skeleton.c |   49 ++++++++++++++++++++++---------------------
>  1 files changed, 25 insertions(+), 24 deletions(-)

ACK but git-am (everybody's patch import tool) says the patch is corrupted


