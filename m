Return-Path: <linux-kernel-owner+w=401wt.eu-S1757132AbYC2Br1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132AbYC2Br1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 21:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754609AbYC2BrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 21:47:16 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48722 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753167AbYC2BrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 21:47:15 -0400
Message-ID: <47ED9FA1.8000000@garzik.org>
Date: Fri, 28 Mar 2008 21:47:13 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Bryan Wu <cooloney@kernel.org>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH 1/2] Blackfin EMAC driver: finish removing remnants of
 old BF537_PORT_H option
References: <> <1206580918-24720-2-git-send-email-cooloney@kernel.org>
In-Reply-To: <1206580918-24720-2-git-send-email-cooloney@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Wu wrote:
> From: Mike Frysinger <vapier.adi@gmail.com>
> 
> Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
>  arch/blackfin/mach-bf537/head.S |   12 ------------
>  drivers/net/Kconfig             |    2 +-
>  2 files changed, 1 insertions(+), 13 deletions(-)

ACK

please send via blackfin arch tree to Linus


