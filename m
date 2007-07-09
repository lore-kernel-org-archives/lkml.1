Return-Path: <linux-kernel-owner+w=401wt.eu-S1755976AbXGIMMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbXGIMMI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 08:12:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbXGIML5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 08:11:57 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60870 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752016AbXGIML5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 08:11:57 -0400
Date: Mon, 9 Jul 2007 13:18:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Hemanth <canfisa@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Any way to update DMI tables programatically
Message-ID: <20070709131821.0e6d83da@the-village.bc.nu>
In-Reply-To: <233208.9076.qm@web32712.mail.mud.yahoo.com>
References: <393903.64336.qm@web32715.mail.mud.yahoo.com>
	<233208.9076.qm@web32712.mail.mud.yahoo.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2007 04:27:26 -0700 (PDT)
Hemanth <canfisa@yahoo.com> wrote:

> Is there any API/function in Redhat Linux to update
> specific entries in the DMI table ? Either a driver
> and app combination ? Any existing features in the
> Linux kernel to do this ? Any existing tools ?
> (execuses If I posted here wrongly, but I am sure
> people out there would help me)

The DMI table is provided by the BIOS and there isn't an OS way to force
the BIOS to change it. A few systems have a different 16bit BIOS entry
point for setting the system id.

