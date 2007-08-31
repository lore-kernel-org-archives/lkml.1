Return-Path: <linux-kernel-owner+w=401wt.eu-S965435AbXHaNiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965435AbXHaNiK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 09:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965118AbXHaNhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 09:37:55 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58566 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965056AbXHaNhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 09:37:54 -0400
Message-ID: <46D819B0.1070606@garzik.org>
Date: Fri, 31 Aug 2007 09:37:52 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Divy Le Ray <divy@chelsio.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 8/11] cxgb3 - Update internal memory management
References: <20070822034941.9387.79621.stgit@speedy5>
In-Reply-To: <20070822034941.9387.79621.stgit@speedy5>
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
> Set PM1 internal memory to round robin mode
> It balances access to this internal memory for multiport adapters.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>
> ---
> 
>  drivers/net/cxgb3/regs.h  |    2 ++
>  drivers/net/cxgb3/t3_hw.c |    2 ++
>  2 files changed, 4 insertions(+), 0 deletions(-)

applied patches 1-8


