Return-Path: <linux-kernel-owner+w=401wt.eu-S1758195AbXHNWSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195AbXHNWSw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 18:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936486AbXHNWES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 18:04:18 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47423 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935617AbXHNWEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 18:04:14 -0400
Message-ID: <46C226D1.4070203@pobox.com>
Date: Tue, 14 Aug 2007 18:04:01 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] remove Documentation/networking/net-modules.txt
References: <20070814212604.GW18945@stusta.de>
In-Reply-To: <20070814212604.GW18945@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> According to git, the only one who touched this file during the last
> 5 years was me when removing drivers...
> 
> modinfo offers less ancient information.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 
> This patch has been sent on:
> - 23 Jul 2007
> 
>  Documentation/networking/00-INDEX        |    2 
>  Documentation/networking/net-modules.txt |  315 -----------------------
>  2 files changed, 317 deletions(-)

NAK, IMO it's still use for ancient drivers


