Return-Path: <linux-kernel-owner+w=401wt.eu-S1764646AbXHWO7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764646AbXHWO7k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 10:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762688AbXHWO7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 10:59:33 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4392 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758648AbXHWO7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 10:59:32 -0400
Subject: Re: [PATCH] Add MAINTAINERS entry for IOC3 serial driver
From: Joe Perches <joe@perches.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Patrick Gefre <pfg@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070822194440.GA3903@linux-mips.org>
References: <Pine.SGI.3.96.1070815090732.63602A-100000@fsgi900.americas.sgi.com>
	 <1187199095.7443.25.camel@localhost> <46CB73FD.10009@sgi.com>
	 <20070822194440.GA3903@linux-mips.org>
Content-Type: text/plain
Date: Thu, 23 Aug 2007 07:59:03 -0700
Message-Id: <1187881143.32738.12.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-22 at 20:44 +0100, Ralf Baechle wrote:
> The IOC3 is a multifunction device but not in sense of the PCI
> specification.  Currently its ethernet and serial functionality are
> supported by two separate drivers authored and maintained by different
> people, so MAINTAINERS should reflect that.

What I have right now:

IOC3 ETHERNET DRIVER
P:	Ralf Baechle
M:	ralf@linux-mips.org
L:	linux-mips@linux-mips.org
S:	Maintained
F:	drivers/net/ioc3-eth.c

IOC3 SERIAL DRIVER
P:	Pat Gefre
M:	pfg@sgi.com
L:	linux-mips@linux-mips.org
S:	Maintained
F:	drivers/serial/ioc3_serial.c


