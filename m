Return-Path: <linux-kernel-owner+w=401wt.eu-S1761757AbXE1WjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761757AbXE1WjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 18:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbXE1WjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 18:39:07 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48882 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbXE1WjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 18:39:04 -0400
Message-ID: <465B5A06.8030402@garzik.org>
Date: Mon, 28 May 2007 18:39:02 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: divy@chelsio.com
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 3/7] cxgb3 - Fix direct XAUI support
References: <20070526225958.12133.84586.stgit@localhost.localdomain>
In-Reply-To: <20070526225958.12133.84586.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

divy@chelsio.com wrote:
> From: Divy Le Ray <divy@chelsio.com>
> 
> Check all lanes for link status on direct XAUI cards.
> Don't assume that direct XAUI always uses XGMAC 1.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>
> ---
> 
>  drivers/net/cxgb3/ael1002.c |   10 ++++++++--
>  drivers/net/cxgb3/regs.h    |    2 ++
>  2 files changed, 10 insertions(+), 2 deletions(-)

ACK


