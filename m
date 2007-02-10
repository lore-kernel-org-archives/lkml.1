Return-Path: <linux-kernel-owner+w=401wt.eu-S1751838AbXBJUVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838AbXBJUVu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 15:21:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbXBJUVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 15:21:50 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38477 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751838AbXBJUVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 15:21:49 -0500
Date: Sat, 10 Feb 2007 20:35:04 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: "Patrick Ale" <patrick.ale@gmail.com>
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: libsata tests started
Message-ID: <20070210203504.129b35ac@localhost.localdomain>
In-Reply-To: <8d158e1f0702101214j603e1880i7eae2d94b446bc0b@mail.gmail.com>
References: <8d158e1f0702100822i28d0bcds91cf27fc34534d2c@mail.gmail.com>
	<20070210114155.6f7433c8.randy.dunlap@oracle.com>
	<8d158e1f0702101214j603e1880i7eae2d94b446bc0b@mail.gmail.com>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > libsata == libata ?
> I don't think there is a seperate libata, it's all put under libsata
> if I understand the working correctly (Alan, don't sue me if I am
> wrong).

Right umm "Your honor the gentleman is human, this is not acceptable" ?

It is in drivers/ata the files are libata-* so it's normally known as
"libata", so libsata == libata.
 
> Maybe it *IS* a nice idea to outline some standard tests that
> developers want to have carried out or some specific tests to trace
> bugs or test if a patch/fix does its work.. But that's not up to me, I
> am not a coder, I can do some very basic stuff in C, that's where
> programming ends for me, unless it's shell scripting.

Beating the crap out of it using it for real work is one excellent form
of testing. We aren't yet at the point of only worrying about benchmark
tuning and corner cases.

Alan
