Return-Path: <linux-kernel-owner+w=401wt.eu-S964798AbXHaJhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964798AbXHaJhv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 05:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932564AbXHaJh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 05:37:28 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:41827 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932517AbXHaJh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 05:37:26 -0400
Message-ID: <46D7E155.409@garzik.org>
Date: Fri, 31 Aug 2007 05:37:25 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Sonic Zhang <sonic.adi@gmail.com>
CC: Linux IDE <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH take #6] [libata] libata driver for bf548 on chip ATAPI
 controller.
References: <1187673151.16526.5.camel@sevens.analog.com>
In-Reply-To: <1187673151.16526.5.camel@sevens.analog.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sonic Zhang wrote:
> Fix all issues pointed out in Jeff's email.
> 
> Acked-by: Alan Cox <alan@redhat.com>
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> ---
>  drivers/ata/Kconfig      |   16
>  drivers/ata/Makefile     |    1
>  drivers/ata/pata_bf54x.c | 1627 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 1644 insertions(+)

applied


