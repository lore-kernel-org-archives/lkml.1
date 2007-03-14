Return-Path: <linux-kernel-owner+w=401wt.eu-S1030696AbXCNJLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030696AbXCNJLN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030731AbXCNJLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:11:13 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38577 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030696AbXCNJLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:11:12 -0400
Message-ID: <45F7BC15.6040304@garzik.org>
Date: Wed, 14 Mar 2007 05:10:45 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       ralf@linux-mips.org
Subject: Re: [PATCH 1/13] ibmtr probe is __devinit, not __init
References: <E1HRPPB-0001pF-NP@ZenIV.linux.org.uk>
In-Reply-To: <E1HRPPB-0001pF-NP@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> used by ->attach() in pcmcia analog
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  drivers/net/pcmcia/ibmtr_cs.c |    4 ++--
>  drivers/net/tokenring/ibmtr.c |    4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)

ACK


