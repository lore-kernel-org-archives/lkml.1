Return-Path: <linux-kernel-owner+w=401wt.eu-S942395AbXHNFvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942395AbXHNFvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 01:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756160AbXHNFuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 01:50:24 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52063 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754897AbXHNFuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 01:50:21 -0400
Message-ID: <46C14297.1050800@garzik.org>
Date: Tue, 14 Aug 2007 01:50:15 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: surya.prabhakar@wipro.com
CC: mikep@linuxtr.net, netdev@vger.kernel.org, linux-tr@linuxtr.net,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       kernel-janitors <kernel-janitors@lists.osdl.org>
Subject: Re: drivers/net/tokenring/3c359.c
References: <1187000010.29518.27.camel@bluegenie>
In-Reply-To: <1187000010.29518.27.camel@bluegenie>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Surya Prabhakar N wrote:
> Hi,
>    Replacing kmalloc with kzalloc and cleaning up memset in 
> drivers/net/tokenring/3c359.c
> 
> 
> Signed-off-by: Surya Prabhakar <surya.prabhakar@wipro.com>

applied


