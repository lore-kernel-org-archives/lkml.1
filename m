Return-Path: <linux-kernel-owner+w=401wt.eu-S1755239AbXKXDLJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbXKXDLJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 22:11:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754850AbXKXDKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 22:10:50 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:44370 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754820AbXKXDKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 22:10:48 -0500
Message-ID: <47479636.4090102@garzik.org>
Date: Fri, 23 Nov 2007 22:10:46 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Bryan Wu <bryan.wu@analog.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Mike Frysinger <michael.frysinger@analog.com>
Subject: Re: [PATCH 1/2] Blackfin SMC91x Driver: punt CONFIG_BFIN -- we already
 have CONFIG_BLACKFIN
References: <1195811751-25319-1-git-send-email-bryan.wu@analog.com> <1195811751-25319-2-git-send-email-bryan.wu@analog.com>
In-Reply-To: <1195811751-25319-2-git-send-email-bryan.wu@analog.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Wu wrote:
> From: Mike Frysinger <michael.frysinger@analog.com>
> 
> Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
> Signed-off-by: Bryan Wu <bryan.wu@analog.com>
> ---
>  drivers/net/Kconfig  |    2 +-
>  drivers/net/smc91x.h |    2 +-

applied 1-2 to #upstream-fixes


