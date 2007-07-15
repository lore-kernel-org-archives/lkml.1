Return-Path: <linux-kernel-owner+w=401wt.eu-S1755795AbXGOUQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795AbXGOUQS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 16:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbXGOUQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 16:16:09 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52604 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515AbXGOUQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 16:16:08 -0400
Message-ID: <469A8080.1050308@garzik.org>
Date: Sun, 15 Jul 2007 16:16:00 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fallout from Auke's pci ->revision patch
References: <E1IAAH8-000564-0G@ZenIV.linux.org.uk>
In-Reply-To: <E1IAAH8-000564-0G@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  drivers/net/tulip/tulip_core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

ACK



