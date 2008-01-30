Return-Path: <linux-kernel-owner+w=401wt.eu-S1758251AbYA3Itl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758251AbYA3Itl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 03:49:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758017AbYA3It1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 03:49:27 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:33490 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758009AbYA3ItZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 03:49:25 -0500
Message-ID: <47A03A12.60806@garzik.org>
Date: Wed, 30 Jan 2008 03:49:22 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jike Song <albcamus@gmail.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pci-skeleton: Misc fixes to build neatly
References: <1201157496-20665-1-git-send-email-albcamus@gmail.com> <1201157496-20665-2-git-send-email-albcamus@gmail.com>
In-Reply-To: <1201157496-20665-2-git-send-email-albcamus@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jike Song wrote:
> The pci-skeleton.c has several problems with compilation, such as missing args
> when calling synchronize_irq(). Fix it.
> 
> Signed-off-by: Jike Song <albcamus@gmail.com>
> ---
>  drivers/net/pci-skeleton.c |   49 ++++++++++++++++++++++---------------------
>  1 files changed, 25 insertions(+), 24 deletions(-)

applied


