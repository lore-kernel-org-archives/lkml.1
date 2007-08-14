Return-Path: <linux-kernel-owner+w=401wt.eu-S940194AbXHNFmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940194AbXHNFmJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 01:42:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938691AbXHNFlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 01:41:16 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46698 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761908AbXHNFlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 01:41:10 -0400
Message-ID: <46C14075.6030101@garzik.org>
Date: Tue, 14 Aug 2007 01:41:09 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Divy Le Ray <divy@chelsio.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 1/13] cxgb3 - MAC workaround update
References: <20070811062933.8022.51781.stgit@speedy5>
In-Reply-To: <20070811062933.8022.51781.stgit@speedy5>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Divy Le Ray wrote:
> From: Divy Le Ray <divy@chelsio.com>
> 
> Update the MAC workaround to deal with switches that do not
> honor pause frames.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>
> ---
> 
>  drivers/net/cxgb3/common.h |    1 +
>  drivers/net/cxgb3/xgmac.c  |   22 +++++++++++-----------
>  2 files changed, 12 insertions(+), 11 deletions(-)

applied


