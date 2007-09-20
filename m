Return-Path: <linux-kernel-owner+w=401wt.eu-S1754820AbXITESi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbXITESi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 00:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbXITES2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 00:18:28 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:42227 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbXITES1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 00:18:27 -0400
Message-ID: <46F1F490.2040605@garzik.org>
Date: Thu, 20 Sep 2007 00:18:24 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Vitaly Bordug <vitb@kernel.crashing.org>
CC: linuxppc-dev@ozlabs.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] [FS_ENET] TX stuff should use fep->tx_lock,	instead
 of fep->lock.
References: <20070918160527.13525.80935.stgit@localhost.localdomain>
In-Reply-To: <20070918160527.13525.80935.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vitaly Bordug wrote:
> Signed-off-by: Vitaly Bordug <vitb@kernel.crashing.org>
> 
> ---
> 
>  drivers/net/fs_enet/fs_enet-main.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)

applied 1-2, after hand-editing the subject line to remove brackets from 
around "[FS_ENET]"

everything within [ and ] is removed, before copying to changelog, so 
please be careful

See http://linux.yyz.us/patch-format.html for more info.

	Jeff


