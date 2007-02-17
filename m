Return-Path: <linux-kernel-owner+w=401wt.eu-S932745AbXBQUcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932745AbXBQUcT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 15:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932758AbXBQUcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 15:32:19 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:47840 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932745AbXBQUcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 15:32:18 -0500
Message-ID: <45D7664F.40400@garzik.org>
Date: Sat, 17 Feb 2007 15:32:15 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Steve Wise <swise@opengridcomputing.com>
CC: netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Divy Le Ray <divy@chelsio.com>
Subject: Re: [PATCH] cxgb3 Fix copyrights in the cxgb3 driver.
References: <1171569189.13282.57.camel@stevo-desktop>
In-Reply-To: <1171569189.13282.57.camel@stevo-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Steve Wise wrote:
> Fix copyrights in the cxgb3 driver.
> 
> Remove the Open Grid Computing copyright.  It shouldn't be there.
> 
> Signed-off-by: Steve Wise <swise@opengridcomputing.com>
> ---
> 
>  drivers/net/cxgb3/cxgb3_defs.h    |    1 -
>  drivers/net/cxgb3/cxgb3_offload.c |    1 -
>  drivers/net/cxgb3/cxgb3_offload.h |    1 -
>  drivers/net/cxgb3/l2t.c           |    1 -
>  drivers/net/cxgb3/l2t.h           |    1 -
>  drivers/net/cxgb3/t3cdev.h        |    1 -
>  6 files changed, 0 insertions(+), 6 deletions(-)

applied


