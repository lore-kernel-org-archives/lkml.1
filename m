Return-Path: <linux-kernel-owner+w=401wt.eu-S1946605AbXBIQJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946605AbXBIQJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:09:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946599AbXBIQJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:09:47 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:56568 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946607AbXBIQJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:09:46 -0500
Message-ID: <45CC9CAF.1010900@garzik.org>
Date: Fri, 09 Feb 2007 11:09:19 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spider_net breakage from class_device -> device
References: <E1HFYFM-0004ql-0L@ZenIV.linux.org.uk>
In-Reply-To: <E1HFYFM-0004ql-0L@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  drivers/net/spider_net.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

ACK

