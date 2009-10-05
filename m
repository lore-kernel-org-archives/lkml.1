Return-Path: <linux-kernel-owner+w=401wt.eu-S1758234AbZJEHQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234AbZJEHQx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 03:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756147AbZJEHQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 03:16:52 -0400
Received: from mail.perches.com ([173.55.12.10]:1843 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755487AbZJEHQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 03:16:51 -0400
Subject: Re: [PATCH 21/21] drivers/net/tlan.h: Convert printk(KERN_DEBUG to
 pr_dbg(
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, chessman@tux.org, netdev@vger.kernel.org
In-Reply-To: <20091005.001240.111554671.davem@davemloft.net>
References: <cover.1254701151.git.joe@perches.com>
	 <cover.1254701151.git.joe@perches.com>
	 <29c66ee0bae26a0c352b4605e3f1fcbe0612f3a5.1254701151.git.joe@perches.com>
	 <20091005.001240.111554671.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Oct 2009 00:16:14 -0700
Message-Id: <1254726974.1799.315.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-05 at 00:12 -0700, David Miller wrote:
> From: Joe Perches <joe@perches.com>
> Date: Sun,  4 Oct 2009 17:53:48 -0700
> > Removed "TLAN: " prefix from debug printks, it's added by pr_fmt
> > Signed-off-by: Joe Perches <joe@perches.com>
> Applied to net-next-2.6

Patches 20 and 21 depend on patch 1, which introduces pr_dbg
to kernel.h.  Compile failure otherwise.



