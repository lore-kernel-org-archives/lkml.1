Return-Path: <linux-kernel-owner+w=401wt.eu-S967937AbXEHFUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967937AbXEHFUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 01:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967881AbXEHFUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 01:20:33 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:54399 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967880AbXEHFUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 01:20:32 -0400
Message-ID: <4640089C.7080900@garzik.org>
Date: Tue, 08 May 2007 01:20:28 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jay Cliburn <jacliburn@bellsouth.net>
CC: csnook@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       atl1-devel@lists.sourceforge.net
Subject: Re: [PATCH 1/2] atl1: use dev_printk macros
References: <11779009311121-git-send-email-jacliburn@bellsouth.net> <11779009313497-git-send-email-jacliburn@bellsouth.net>
In-Reply-To: <11779009313497-git-send-email-jacliburn@bellsouth.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jay Cliburn wrote:
> Use dev_printk macros for PCI related errors, warnings, debug and info
> console messages.
> 
> Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
> ---
>  drivers/net/atl1/atl1_ethtool.c |   19 +++------
>  drivers/net/atl1/atl1_hw.c      |   22 +++++------
>  drivers/net/atl1/atl1_main.c    |   83 +++++++++++++++++---------------------
>  drivers/net/atl1/atl1_param.c   |   31 +++++++--------
>  4 files changed, 68 insertions(+), 87 deletions(-)

applied 1-2


