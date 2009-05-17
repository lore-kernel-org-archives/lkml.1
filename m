Return-Path: <linux-kernel-owner+w=401wt.eu-S1755901AbZEQH4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbZEQH4y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 03:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbZEQH4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 03:56:37 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:36299 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbZEQH4f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 03:56:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=X7c2MVTj4k/AnK7uvlkcVCIvOeoplXJ42k08pmwFBit7aAr2wlq29AAAD2UuO8tHJ1
         Ow+pH30aWlu/YLBcqmFiTYjx6lNnYBBCB6tdMIw85cb5v7h5LfBkbOxvmMAb+80RQHIs
         Cd7H8TgEKLxFGFkZj1DCusZGAw2aKyekk+LuU=
MIME-Version: 1.0
In-Reply-To: <yO1BmxN79sN.A.xAG.8_zDKB@chimera>
References: <yO1BmxN79sN.A.xAG.8_zDKB@chimera>
Date: Sun, 17 May 2009 09:56:34 +0200
Message-ID: <8db1092f0905170056x56867507i7b8c32ff102e2d77@mail.gmail.com>
Subject: Re: 2.6.30-rc6: Reported regressions 2.6.28 -> 2.6.29
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/16 Rafael J. Wysocki <rjw@sisk.pl>:


> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12499
> Subject         : Problem with using bluetooth adaper connected to usb port
> Submitter       : Maciej Rutecki <maciej.rutecki@gmail.com>
> Date            : 2009-01-13 18:34 (124 days old)
> References      : http://marc.info/?l=linux-kernel&m=123187185426236&w=4
> Handled-By      : Marcel Holtmann <marcel@holtmann.org>

2.6.30-rc6 works fine. Please remove it.


Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
