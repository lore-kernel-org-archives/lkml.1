Return-Path: <linux-kernel-owner+w=401wt.eu-S1757291AbZFWF5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291AbZFWF5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 01:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbZFWF51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 01:57:27 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47994 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329AbZFWF51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 01:57:27 -0400
Message-ID: <4A406EC5.4010009@garzik.org>
Date: Tue, 23 Jun 2009 01:57:25 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: linuxppc-dev@ozlabs.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Dave Liu <daveliu@freescale.com>
Subject: Re: [PATCH] sata_fsl: Add power mgmt support
References: <1244692417-18484-1-git-send-email-galak@kernel.crashing.org>
In-Reply-To: <1244692417-18484-1-git-send-email-galak@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala wrote:
> From: Dave Liu <daveliu@freescale.com>
> 
> Signed-off-by: Dave Liu <daveliu@freescale.com>
> Signed-off-by: Liu Yu <yu.liu@freescale.com>
> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
> ---
>  drivers/ata/sata_fsl.c |   35 +++++++++++++++++++++++++++++++++++
>  1 files changed, 35 insertions(+), 0 deletions(-)

applied


