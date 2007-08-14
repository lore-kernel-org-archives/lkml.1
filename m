Return-Path: <linux-kernel-owner+w=401wt.eu-S942373AbXHNFnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942373AbXHNFnx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 01:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932136AbXHNFmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 01:42:55 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46727 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S941225AbXHNFmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 01:42:53 -0400
Message-ID: <46C140DB.7030909@garzik.org>
Date: Tue, 14 Aug 2007 01:42:51 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Divy Le Ray <divy@chelsio.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 3/13] cxgb3 - SGE doorbell overflow warning
References: <20070811062944.8058.38057.stgit@speedy5>
In-Reply-To: <20070811062944.8058.38057.stgit@speedy5>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Divy Le Ray wrote:
> From: Divy Le Ray <divy@chelsio.com>
> 
> Log doorbell Fifo overflow
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>
> ---
> 
>  drivers/net/cxgb3/regs.h |    8 ++++++++
>  drivers/net/cxgb3/sge.c  |    4 ++++
>  2 files changed, 12 insertions(+), 0 deletions(-)

ACK, but not applied since patch #2 was not applied


