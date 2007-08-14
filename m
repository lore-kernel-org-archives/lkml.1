Return-Path: <linux-kernel-owner+w=401wt.eu-S943268AbXHNFtD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943268AbXHNFtD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 01:49:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S942692AbXHNFqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 01:46:55 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:37835 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S942619AbXHNFqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 01:46:53 -0400
Message-ID: <46C141CB.8050305@garzik.org>
Date: Tue, 14 Aug 2007 01:46:51 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Divy Le Ray <divy@chelsio.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 12/13] cxgb3 - log and clear PEX errors
References: <20070811063031.8221.70512.stgit@speedy5>
In-Reply-To: <20070811063031.8221.70512.stgit@speedy5>
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
> Clear pciE PEX errors late at module load time.
> Log details when PEX errors occur.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>
> ---
> 
>  drivers/net/cxgb3/t3_hw.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)

ACK 10-12


