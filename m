Return-Path: <linux-kernel-owner+w=401wt.eu-S1764216AbXGXUhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764216AbXGXUhT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 16:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757942AbXGXUhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 16:37:05 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58988 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757944AbXGXUhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 16:37:02 -0400
Message-ID: <46A662EB.6070707@garzik.org>
Date: Tue, 24 Jul 2007 16:36:59 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Jay Cliburn <jacliburn@bellsouth.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       atl1-devel@lists.sourceforge.net, csnook@redhat.com
Subject: Re: [PATCH 1/5] atl1: change tpd_avail function name
References: <1184888714454-git-send-email-jacliburn@bellsouth.net> <1184888714650-git-send-email-jacliburn@bellsouth.net>
In-Reply-To: <1184888714650-git-send-email-jacliburn@bellsouth.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jay Cliburn wrote:
> Change tpd_avail() to atl1_tpd_avail().
> 
> Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
> ---
>  drivers/net/atl1/atl1_main.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

applied 1-5


