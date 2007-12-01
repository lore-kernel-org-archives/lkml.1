Return-Path: <linux-kernel-owner+w=401wt.eu-S1752956AbXLAVe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956AbXLAVe0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 16:34:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750981AbXLAVeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 16:34:09 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:32876 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbXLAVeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 16:34:05 -0500
Message-ID: <4751D34B.9030908@garzik.org>
Date: Sat, 01 Dec 2007 16:34:03 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Divy Le Ray <divy@chelsio.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       greearb@candelatech.com
Subject: Re: [PATCH 1/3] cxgb - fix T2 GSO
References: <20071127213009.804.49490.stgit@speedy5>
In-Reply-To: <20071127213009.804.49490.stgit@speedy5>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Divy Le Ray wrote:
> From: Divy Le Ray <divy@chelsio.com>
> 
> The patch ensures that a GSO skb has enough headroom
> to push an encapsulating cpl_tx_pkt_lso header.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>
> ---

applied 1-3


