Return-Path: <linux-kernel-owner+w=401wt.eu-S1757187AbXGOUQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187AbXGOUQj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 16:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751638AbXGOUQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 16:16:29 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52611 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284AbXGOUQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 16:16:29 -0400
Message-ID: <469A8097.7060502@garzik.org>
Date: Sun, 15 Jul 2007 16:16:23 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ax88796: dev_dbg() wants device, not platform device
References: <E1IAAGx-00055h-WB@ZenIV.linux.org.uk>
In-Reply-To: <E1IAAGx-00055h-WB@ZenIV.linux.org.uk>
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
>  drivers/net/ax88796.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

ACK


