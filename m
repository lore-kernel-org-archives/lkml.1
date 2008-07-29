Return-Path: <linux-kernel-owner+w=401wt.eu-S1758255AbYG2Vt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255AbYG2Vt5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 17:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754672AbYG2Vtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 17:49:46 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:56419 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754668AbYG2Vtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 17:49:46 -0400
Message-ID: <488F9076.9060005@garzik.org>
Date: Tue, 29 Jul 2008 17:49:42 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Bryan Wu <cooloney@kernel.org>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH 1/3] Blackfin EMAC Driver: add proper __devinit/__devexit
 markings
References: <1217169905-7055-1-git-send-email-cooloney@kernel.org> <1217169905-7055-2-git-send-email-cooloney@kernel.org>
In-Reply-To: <1217169905-7055-2-git-send-email-cooloney@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
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
>  drivers/net/bfin_mac.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>

applied 1-3


