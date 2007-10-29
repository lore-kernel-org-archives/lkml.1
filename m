Return-Path: <linux-kernel-owner+w=401wt.eu-S1755892AbXJ2Joh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbXJ2Joh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 05:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbXJ2Jo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 05:44:28 -0400
Received: from sa3.bezeqint.net ([192.115.104.17]:55875 "EHLO sa3.bezeqint.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110AbXJ2Jo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 05:44:27 -0400
X-Greylist: delayed 1308 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Oct 2007 05:44:27 EDT
Message-ID: <4725AB71.6000308@panasas.com>
Date: Mon, 29 Oct 2007 11:44:17 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] scsi/seagate.c: remove dead code
References: <20071028155142.GB7227@stusta.de>
In-Reply-To: <20071028155142.GB7227@stusta.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28 2007 at 17:51 +0200, Adrian Bunk <bunk@kernel.org> wrote:
> This patch removes obviously dead code.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 
>  drivers/scsi/seagate.c |    2 --
>  1 file changed, 2 deletions(-)
> 

Actually I have sent a patch to completely remove this driver.
http://www.spinics.net/lists/linux-scsi/msg20308.html

Does any one objects?

Boaz
