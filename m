Return-Path: <linux-kernel-owner+w=401wt.eu-S1757044AbYFYDJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757044AbYFYDJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 23:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754175AbYFYDJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 23:09:28 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48110 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754094AbYFYDJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 23:09:28 -0400
Message-ID: <4861B6E4.3040803@garzik.org>
Date: Tue, 24 Jun 2008 23:09:24 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Divy Le Ray <divy@chelsio.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 2.6.27] cxgb3 - add missing adapter type for RDMA
References: <20080623180259.12447.52386.stgit@speedy5>
In-Reply-To: <20080623180259.12447.52386.stgit@speedy5>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Divy Le Ray wrote:
> From: Divy Le Ray <divy@chelsio.com>
> 
> T3C added support is now reflected to the RDMA driver.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>
> ---
> 
>  drivers/net/cxgb3/cxgb3_offload.c |   21 ++++++++++++++++++++-
>  drivers/net/cxgb3/t3cdev.h        |    3 ++-
>  2 files changed, 22 insertions(+), 2 deletions(-)

applied


