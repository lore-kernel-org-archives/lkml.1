Return-Path: <linux-kernel-owner+w=401wt.eu-S1754698AbXKCMsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbXKCMsZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 08:48:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753420AbXKCMsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 08:48:16 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:35144 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753429AbXKCMsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 08:48:16 -0400
Message-ID: <472C6E0C.106@pobox.com>
Date: Sat, 03 Nov 2007 08:48:12 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libata: suppress two warnings
References: <20071031145332.01529b7d.sfr@canb.auug.org.au>
In-Reply-To: <20071031145332.01529b7d.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> drivers/ata/libata-core.c:768: warning: 'ata_lpm_enable' defined but not used
> drivers/ata/libata-core.c:784: warning: 'ata_lpm_disable' defined but not used
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/ata/libata-core.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)

applied


