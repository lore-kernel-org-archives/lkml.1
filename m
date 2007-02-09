Return-Path: <linux-kernel-owner+w=401wt.eu-S1752568AbXBIXrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbXBIXrI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 18:47:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752575AbXBIXrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 18:47:08 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39436
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752568AbXBIXrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 18:47:07 -0500
Date: Fri, 09 Feb 2007 15:47:06 -0800 (PST)
Message-Id: <20070209.154706.130238531.davem@davemloft.net>
To: viro@ftp.linux.org.uk
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FRA_{DST,SRC} are le16 for decnet
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1HFaFd-0004NK-22@ZenIV.linux.org.uk>
References: <E1HFaFd-0004NK-22@ZenIV.linux.org.uk>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ftp.linux.org.uk>
Date: Fri, 09 Feb 2007 18:13:37 +0000

> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  net/decnet/dn_rules.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)

Applied.
