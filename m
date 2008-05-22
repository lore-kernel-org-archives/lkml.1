Return-Path: <linux-kernel-owner+w=401wt.eu-S1760936AbYEVLJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760936AbYEVLJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 07:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753624AbYEVLJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 07:09:06 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48261 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752581AbYEVLJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 07:09:05 -0400
Message-ID: <4835544C.2010005@garzik.org>
Date: Thu, 22 May 2008 07:09:00 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Divy Le Ray <divy@chelsio.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 1/3 2.6.27 RESEND] cxgb3 - Fix dma mapping error path
References: <20080522015616.25335.31806.stgit@speedy5>
In-Reply-To: <20080522015616.25335.31806.stgit@speedy5>
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
> Take potential dma mapping errors in account.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>
> ---
> 
>  drivers/net/cxgb3/sge.c |   53 ++++++++++++++++++++++++++++++++++++-----------
>  1 files changed, 41 insertions(+), 12 deletions(-)

applied 1-3


