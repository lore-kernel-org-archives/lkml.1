Return-Path: <linux-kernel-owner+w=401wt.eu-S1759171AbYA3JBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759171AbYA3JBf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 04:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758157AbYA3JBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 04:01:05 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:59303 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758929AbYA3JBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 04:01:03 -0500
Message-ID: <47A03CCB.8080500@garzik.org>
Date: Wed, 30 Jan 2008 04:00:59 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Bryan Wu <bryan.wu@analog.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] [Blackfin] EMAC driver: shorten the mdelay value
 to solve netperf performance issue
References: <1201683148-23931-1-git-send-email-bryan.wu@analog.com> <1201683148-23931-2-git-send-email-bryan.wu@analog.com>
In-Reply-To: <1201683148-23931-2-git-send-email-bryan.wu@analog.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Wu wrote:
> Signed-off-by: Bryan Wu <bryan.wu@analog.com>
> ---
>  drivers/net/bfin_mac.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

applied 1-8


