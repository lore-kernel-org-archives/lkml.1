Return-Path: <linux-kernel-owner+w=401wt.eu-S1751947AbXDHTd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbXDHTd5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 15:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbXDHTd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 15:33:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46288
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751947AbXDHTdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 15:33:55 -0400
Date: Sun, 08 Apr 2007 12:33:55 -0700 (PDT)
Message-Id: <20070408.123355.32624992.davem@davemloft.net>
To: arnd@arndb.de
Cc: hch@lst.de, akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] merge compat_ioctl.h into compat_ioctl.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <200704081651.21148.arnd@arndb.de>
References: <20070408140433.GA28023@lst.de>
	<200704081651.21148.arnd@arndb.de>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Sun, 8 Apr 2007 16:51:20 +0200

> On Sunday 08 April 2007, Christoph Hellwig wrote:
> > 
> > Now that there is no arch-specific compat ioctl handling left there
> > is not point in having a separate copat_ioctl.h, so merge it into
> > compat_ioctl.c
> 
> Yes, definitely a good idea.
> 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
>  
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: David S. Miller <davem@davemloft.net>
