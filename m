Return-Path: <linux-kernel-owner+w=401wt.eu-S1756230AbYEVLKK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbYEVLKK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 07:10:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762321AbYEVLJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 07:09:49 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48266 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756610AbYEVLJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 07:09:12 -0400
Message-ID: <48355455.80607@pobox.com>
Date: Thu, 22 May 2008 07:09:09 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] misc drivers/net endianness noise
References: <20080521003430.GB28946@ZenIV.linux.org.uk>
In-Reply-To: <20080521003430.GB28946@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  drivers/net/3c509.c                    |   15 +++++++--------
>  drivers/net/atlx/atl1.c                |    2 +-
>  drivers/net/usb/catc.c                 |    5 ++++-
>  drivers/net/usb/rndis_host.c           |    4 ++--
>  drivers/net/wireless/zd1211rw/zd_mac.c |    2 +-
>  drivers/net/wireless/zd1211rw/zd_usb.c |    2 +-
>  6 files changed, 16 insertions(+), 14 deletions(-)

applied


