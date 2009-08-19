Return-Path: <linux-kernel-owner+w=401wt.eu-S1753076AbZHSTNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbZHSTNf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 15:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753008AbZHSTNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 15:13:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54002
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753012AbZHSTNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 15:13:32 -0400
Date: Wed, 19 Aug 2009 12:13:44 -0700 (PDT)
Message-Id: <20090819.121344.67683197.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, akpm@linux-foundation.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: fix ks8851 build errors
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090819085202.810630a2.randy.dunlap@oracle.com>
References: <20090818152705.64557a0b.randy.dunlap@oracle.com>
	<20090818.201200.69809801.davem@davemloft.net>
	<20090819085202.810630a2.randy.dunlap@oracle.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Wed, 19 Aug 2009 08:52:02 -0700

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix build errors due to missing Kconfig select of CRC32:
> 
> ks8851.c:(.text+0x7d2ee): undefined reference to `crc32_le'
> ks8851.c:(.text+0x7d2f5): undefined reference to `bitrev32'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Applied, thanks Randy.
