Return-Path: <linux-kernel-owner+w=401wt.eu-S1753808AbXIHQI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbXIHQI0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 12:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753143AbXIHQIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 12:08:19 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:33097 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110AbXIHQIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 12:08:18 -0400
Date: Sat, 8 Sep 2007 18:08:17 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Al Boldi <a1426z@gawab.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: sata & scsi suggestion for make menuconfig
In-Reply-To: <200709081703.31280.a1426z@gawab.com>
Message-ID: <Pine.LNX.4.64.0709081807580.1625@fbirervta.pbzchgretzou.qr>
References: <200709080652.02614.a1426z@gawab.com> <20070908144758.37ab3c76@the-village.bc.nu>
 <200709081703.31280.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 8 2007 17:03, Al Boldi wrote:
>Alan Cox wrote:
>> > I once sent a patch to make libata a submenu of scsi.
>>
>> Which is wrong
>>
>> Nakked-by: Alan Cox <alan@redhat.com>
>>
>> The general comments about moving this stuff around and making it clearer
>> what sd/sr etc are nowdays are good but hiding libata under SCSI will
>> cause even more confusion than it cures
>
>That's easy to fix:  just change the SCSI heading to include a libata hint.

Let's not. I am perfectly fine with how things currently are, plus optionally
Stefan Richter's suggestion.


	Jan
-- 
