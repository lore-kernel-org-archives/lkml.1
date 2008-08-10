Return-Path: <linux-kernel-owner+w=401wt.eu-S1753866AbYHJGyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbYHJGyZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 02:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751327AbYHJGyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 02:54:16 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:1213 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbYHJGyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 02:54:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=EAoz8c5zHAQ+wG8C5uSmOJbFcmZs5ComX6439Yzb0gk2Isbp3yu3DY7+Krwj7JMjOm
         IShm3xrlIdPUvQmFy7EJ1f1+1V48alpaaulhGtu9k5gFa+t+7pROkUEIwl+ila9jiNCE
         j3Z3JifDH62uCPPElOmm7yg67g0OmsY4axJGA=
Message-ID: <3f9a31f40808092354s3d057effm6ed1d2f506fb4637@mail.gmail.com>
Date: Sun, 10 Aug 2008 12:24:14 +0530
From: "Jaswinder Singh" <jaswinderlinux@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #11272] BUG: parport_serial in 2.6.27-rc1 for NetMos Technology PCI 9835
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "David Woodhouse" <dwmw2@infradead.org>, linux-serial@vger.kernel.org
In-Reply-To: <cX_-nNkxKaF.A.F6.BDjnIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik>
	 <cX_-nNkxKaF.A.F6.BDjnIB@albercik>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

On Sun, Aug 10, 2008 at 4:13 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=11272
> Subject         : BUG: parport_serial in 2.6.27-rc1 for NetMos Technology PCI 9835
> Submitter       : Jaswinder Singh <jaswinderlinux@gmail.com>
> Date            : 2008-08-05 15:12 (5 days old)
> References      : http://marc.info/?l=linux-kernel&m=121794900319776&w=4
>
>

This problem still exists on 2.6.27-rc2

When I connect  development boads to /dev/ttyS1 and /dev/ttyS2:
bootloader still prints Junk (Garbage Characters) but when Linux
starts then it becomes readable and normal.

So I thought problem is in bootloader so I connected different kind of
develepment boards and all shows junk characters during boot-loading.

But when I connect  development boads to /dev/ttyS0 : bootloader
messages are readable and normal with same settings.

If you need more info and need help in debugging, please let me know.

Thank you,

Jaswinder Singh.
