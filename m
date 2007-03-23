Return-Path: <linux-kernel-owner+w=401wt.eu-S1753198AbXCWFub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbXCWFub (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 01:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753201AbXCWFub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 01:50:31 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60464 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753196AbXCWFu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 01:50:28 -0400
Message-ID: <46036AA2.2050001@pobox.com>
Date: Fri, 23 Mar 2007 01:50:26 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Dale Farnsworth <dale@farnsworth.org>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mv643xx_eth: add mv643xx_eth_shutdown function
References: <20070320233801.GA24374@xyzzy.farnsworth.org>
In-Reply-To: <20070320233801.GA24374@xyzzy.farnsworth.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dale Farnsworth wrote:
> From: Dale Farnsworth <dale@farnsworth.org>
> 
> mv643xx_eth_shutdown is needed for kexec.
> 
> Signed-off-by: Dale Farnsworth <dale@farnsworth.org>
> 
> ---
>  drivers/net/mv643xx_eth.c |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)

applied


