Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592AbXKXDA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbXKXDA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 22:00:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676AbXKXDAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 22:00:13 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:43496 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753663AbXKXDAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 22:00:11 -0500
Message-ID: <474793B4.6020105@garzik.org>
Date: Fri, 23 Nov 2007 22:00:04 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Divy Le Ray <divy@chelsio.com>
CC: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com, wenxiong@us.ibm.com
Subject: Re: [PATCH 1/9] cxgb3 - fix MSI-X failure path
References: <20071116192139.31024.31482.stgit@speedy5>
In-Reply-To: <20071116192139.31024.31482.stgit@speedy5>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Divy Le Ray wrote:
> From: Divy Le Ray <divy@chelsio.com>
> 
> Return error code when msi-x settings fail.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>
> ---
> 
>  drivers/net/cxgb3/cxgb3_main.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)

applied 1-9 to #upstream, then trimmed all trailing whitespace


