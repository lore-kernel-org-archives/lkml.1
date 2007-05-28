Return-Path: <linux-kernel-owner+w=401wt.eu-S1762923AbXE1Wl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762923AbXE1Wl1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 18:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbXE1WlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 18:41:18 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48895 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442AbXE1WlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 18:41:17 -0400
Message-ID: <465B5A8B.7000701@garzik.org>
Date: Mon, 28 May 2007 18:41:15 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: divy@chelsio.com
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 4/7 RESEND] cxgb3 - Update FW to 4.1
References: <20070526231748.12319.20729.stgit@localhost.localdomain>
In-Reply-To: <20070526231748.12319.20729.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

divy@chelsio.com wrote:
> From: Divy Le Ray <divy@chelsio.com>
> 
> Bump FW version to 4.1.
> Modify chip tuning in consequence.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>
> ---
> 
>  drivers/net/cxgb3/regs.h    |    4 ++++
>  drivers/net/cxgb3/t3_hw.c   |   40 ++++++++++++++++++++++------------------
>  drivers/net/cxgb3/version.h |    2 +-
>  3 files changed, 27 insertions(+), 19 deletions(-)

You think requiring a FIRMWARE UPGRADE is something that should be done 
in the middle of a kernel bugfix series?  What Q/A planet are you from?

This is a completely ridiculous burden you are placing on the individual 
user.  A good driver knows that firmware NOT SHIPPED WITH THE KERNEL 
does not necessarily move in lock-step with the kernel driver.  You are 
welcome to GPL your firmware and ship it of course....

	Jeff



