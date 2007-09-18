Return-Path: <linux-kernel-owner+w=401wt.eu-S1757808AbXIRUIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808AbXIRUIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 16:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754662AbXIRUIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 16:08:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59653
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754951AbXIRUIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 16:08:13 -0400
Date: Tue, 18 Sep 2007 13:08:10 -0700 (PDT)
Message-Id: <20070918.130810.78161599.davem@davemloft.net>
To: hpa@zytor.com
Cc: mchan@broadcom.com, vda.linux@googlemail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: bnx2 dirver's firmware images
From: David Miller <davem@davemloft.net>
In-Reply-To: <46F02688.8030507@zytor.com>
References: <46F01BDE.6020902@zytor.com>
	<20070918.122034.83625273.davem@davemloft.net>
	<46F02688.8030507@zytor.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 18 Sep 2007 12:27:04 -0700

> Well, what I was referring to here, of course, was the initramfs
> integrated in the kernel image, so it all comes out of the kernel build
> tree and produces a single bootable image.  The fact that part of it
> contains userspace code is in that way invisible.
> 
> That was kind of the point here, and the only reason for pushing klibc
> into the kernel build tree at all.  Under the "distros use external
> initrd anyway" school of thought, whatever libc used for that can be
> external anyway.

Sounds good to me :)
