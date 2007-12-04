Return-Path: <linux-kernel-owner+w=401wt.eu-S1753921AbXLDTyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbXLDTyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 14:54:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753195AbXLDTyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 14:54:05 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:47960 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753180AbXLDTyC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 14:54:02 -0500
Message-ID: <4755B058.7070402@garzik.org>
Date: Tue, 04 Dec 2007 14:54:00 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Divy Le Ray <divy@chelsio.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cxgb - revert file mode changes.
References: <20071201235717.22418.24800.stgit@speedy5>
In-Reply-To: <20071201235717.22418.24800.stgit@speedy5>
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
> revert inavertant file mode changes
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>
> ---
> 
>  drivers/net/chelsio/cxgb2.c  |    0 
>  drivers/net/chelsio/pm3393.c |    0 
>  drivers/net/chelsio/sge.c    |    0 
>  drivers/net/chelsio/sge.h    |    0 
>  4 files changed, 0 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/chelsio/cxgb2.c b/drivers/net/chelsio/cxgb2.c
> old mode 100755
> new mode 100644
> diff --git a/drivers/net/chelsio/pm3393.c b/drivers/net/chelsio/pm3393.c
> old mode 100755
> new mode 100644
> diff --git a/drivers/net/chelsio/sge.c b/drivers/net/chelsio/sge.c
> old mode 100755
> new mode 100644
> diff --git a/drivers/net/chelsio/sge.h b/drivers/net/chelsio/sge.h
> old mode 100755
> new mode 100644

applied #upstream-fixes


