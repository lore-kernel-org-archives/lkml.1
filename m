Return-Path: <linux-kernel-owner+w=401wt.eu-S1754743AbYKFFnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbYKFFnA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 00:43:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbYKFFmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 00:42:50 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:34690 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbYKFFmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 00:42:49 -0500
Message-ID: <491283CF.8010302@pobox.com>
Date: Thu, 06 Nov 2008 00:42:39 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] el3_common_init() should be __devinit, not __init
References: <E1KwL59-0000Ug-F1@ZenIV.linux.org.uk>
In-Reply-To: <E1KwL59-0000Ug-F1@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  drivers/net/3c509.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)

applied


