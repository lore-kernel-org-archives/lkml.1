Return-Path: <linux-kernel-owner+w=401wt.eu-S1759825AbXFMTq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759825AbXFMTq3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 15:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754394AbXFMTqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 15:46:17 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38913 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755722AbXFMTqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 15:46:14 -0400
Message-ID: <46704982.5000603@garzik.org>
Date: Wed, 13 Jun 2007 15:46:10 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Divy Le Ray <divy@chelsio.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 1/3] cxgb3 - sge page management
References: <20070531041047.6117.53202.stgit@localhost.localdomain>
In-Reply-To: <20070531041047.6117.53202.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Divy Le Ray wrote:
> From: Divy Le Ray <divy@chelsio.com>
> 
> Streamline sge page management.
> Fix dma mappings when buffers are recycled.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>
> ---
> 
>  drivers/net/cxgb3/adapter.h |   38 ++--
>  drivers/net/cxgb3/sge.c     |  423 ++++++++++++++++++++++---------------------
>  2 files changed, 232 insertions(+), 229 deletions(-)

applied 1-3 to #upstream (2.6.23)


