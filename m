Return-Path: <linux-kernel-owner+w=401wt.eu-S943465AbXHNFtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943465AbXHNFtg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 01:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S942888AbXHNFrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 01:47:09 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:37840 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S941911AbXHNFrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 01:47:06 -0400
Message-ID: <46C141D8.40805@garzik.org>
Date: Tue, 14 Aug 2007 01:47:04 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Divy Le Ray <divy@chelsio.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 13/13] cxgb3 - test MSI capabilities
References: <20070811063036.8239.27320.stgit@speedy5>
In-Reply-To: <20070811063036.8239.27320.stgit@speedy5>
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
> Check that the HW in really in MSI/MSI-X mode
> when it was succesfully enabled.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>
> ---
> 
>  drivers/net/cxgb3/cxgb3_main.c |   42 ++++++++++++++++++++++++++++++++++++++++
>  drivers/net/cxgb3/regs.h       |    4 ++++
>  2 files changed, 46 insertions(+), 0 deletions(-)

we really don't need to be adding this to each driver


