Return-Path: <linux-kernel-owner+w=401wt.eu-S1757036AbXEOTvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036AbXEOTvG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 15:51:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754711AbXEOTu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 15:50:57 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49948 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754684AbXEOTu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 15:50:56 -0400
Message-ID: <464A0F03.3000608@garzik.org>
Date: Tue, 15 May 2007 15:50:27 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] missing includes in mlx4
References: <E1Ho2ow-0003TZ-Au@ZenIV.linux.org.uk>
In-Reply-To: <E1Ho2ow-0003TZ-Au@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  drivers/net/mlx4/alloc.c |    1 +
>  drivers/net/mlx4/eq.c    |    1 +
>  drivers/net/mlx4/icm.c   |    1 +
>  drivers/net/mlx4/reset.c |    1 +
>  4 files changed, 4 insertions(+), 0 deletions(-)

ACK


