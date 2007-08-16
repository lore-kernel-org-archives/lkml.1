Return-Path: <linux-kernel-owner+w=401wt.eu-S1760342AbXHPNzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760342AbXHPNzc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 09:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758217AbXHPNzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 09:55:22 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2824 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757415AbXHPNzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 09:55:21 -0400
Subject: Re: [PATCH] [120/2many] MAINTAINERS - CFAG12864BFB LCD FRAMEBUFFER
	DRIVER
From: Joe Perches <joe@perches.com>
To: Miguel Ojeda <maxextreme@gmail.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <653402b90708160216k1ea20490k7a846bd019e44b3d@mail.gmail.com>
References: <46bff946.crSIrCRHeVaUjuwb%joe@perches.com>
	 <653402b90708160216k1ea20490k7a846bd019e44b3d@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 16 Aug 2007 06:55:07 -0700
Message-Id: <1187272507.5906.80.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-16 at 11:16 +0200, Miguel Ojeda wrote:
> I think you could add also:
>  +F:     Documentation/auxdisplay/cfag12864bfb

This is what I have now:

CFAG12864BFB LCD FRAMEBUFFER DRIVER
P:	Miguel Ojeda Sandonis
M:	maxextreme@gmail.com
L:	linux-kernel@vger.kernel.org
W:	http://auxdisplay.googlepages.com/
S:	Maintained
F:	Documentation/auxdisplay/cfag12864bfb
F:	drivers/auxdisplay/cfag12864bfb.c
F:	include/linux/cfag12864b.h

Joe

