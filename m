Return-Path: <linux-kernel-owner+w=401wt.eu-S942966AbXHNFrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942966AbXHNFrh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 01:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S942147AbXHNFpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 01:45:42 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:37808 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S942610AbXHNFpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 01:45:40 -0400
Message-ID: <46C14182.1030205@garzik.org>
Date: Tue, 14 Aug 2007 01:45:38 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Divy Le Ray <divy@chelsio.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 8/13] cxgb3 - log adapter derial number
References: <20070811063010.8148.57462.stgit@speedy5>
In-Reply-To: <20070811063010.8148.57462.stgit@speedy5>
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
> Log HW serial number when cxgb3 module is loaded.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>
> ---
> 
>  drivers/net/cxgb3/common.h     |    2 ++
>  drivers/net/cxgb3/cxgb3_main.c |    6 ++++--
>  drivers/net/cxgb3/t3_hw.c      |    3 ++-
>  3 files changed, 8 insertions(+), 3 deletions(-)

ACK patches 6-8


