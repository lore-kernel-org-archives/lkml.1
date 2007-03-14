Return-Path: <linux-kernel-owner+w=401wt.eu-S1030846AbXCNJ6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030846AbXCNJ6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:58:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030847AbXCNJ6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:58:12 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38942 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030846AbXCNJ6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:58:10 -0400
Message-ID: <45F7C72E.2010004@pobox.com>
Date: Wed, 14 Mar 2007 05:58:06 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/17] trivial ATA iomem annotations
References: <E1HRPdM-0003Sq-0w@ZenIV.linux.org.uk>
In-Reply-To: <E1HRPdM-0003Sq-0w@ZenIV.linux.org.uk>
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
>  drivers/ata/pata_cs5520.c |    2 +-
>  drivers/ata/sata_sis.c    |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

ACK


