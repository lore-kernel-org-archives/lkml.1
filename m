Return-Path: <linux-kernel-owner+w=401wt.eu-S1756358AbXLGUDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358AbXLGUDK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 15:03:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755764AbXLGUCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 15:02:53 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:40120 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756826AbXLGUCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 15:02:52 -0500
Message-ID: <4759A6EA.1050106@garzik.org>
Date: Fri, 07 Dec 2007 15:02:50 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Divy Le Ray <divy@chelsio.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com, wenxiong@us.ibm.com
Subject: Re: [PATCH 2/2] cxgb3 - Parity initialization for T3C adapters
References: <20071205181527.22106.73134.stgit@speedy5>
In-Reply-To: <20071205181527.22106.73134.stgit@speedy5>
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
> Add parity initialization for T3C adapters.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>
> ---
> 
>  drivers/net/cxgb3/adapter.h       |    1 
>  drivers/net/cxgb3/cxgb3_main.c    |   82 ++++++++++++
>  drivers/net/cxgb3/cxgb3_offload.c |   15 ++
>  drivers/net/cxgb3/regs.h          |  248 +++++++++++++++++++++++++++++++++++++
>  drivers/net/cxgb3/sge.c           |   24 +++-
>  drivers/net/cxgb3/t3_hw.c         |  131 +++++++++++++++++---
>  6 files changed, 472 insertions(+), 29 deletions(-)

dropped patches 2-3, did not apply


