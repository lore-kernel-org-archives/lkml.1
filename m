Return-Path: <linux-kernel-owner+w=401wt.eu-S1753241AbXIHHab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbXIHHab (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 03:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbXIHHaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 03:30:23 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:46563 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbXIHHaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 03:30:21 -0400
Date: Sat, 8 Sep 2007 09:30:21 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: patrizio.bassi@gmail.com,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       "Kernel," <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Alan Cox <alan@redhat.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: libata not working for sis5533
In-Reply-To: <Pine.LNX.4.64.0709031957390.24179@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.64.0709061156220.25942@fbirervta.pbzchgretzou.qr>
References: <46D132C5.5000803@gmail.com> <6bffcb0e0708261627s12e5a9acqef92d0261264a40c@mail.gmail.com>
 <46D8921E.3010304@gmail.com> <46D89429.7080802@gmail.com>
 <20070902114032.7dbfb21a@the-village.bc.nu>
 <Pine.LNX.4.64.0709031957390.24179@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>On Sep 2 2007 11:40, Alan Cox wrote:
>>
>>> i've been out for a week, but found no notice, did i lost any email or
>>> no activity on this issue?
>>
>>I tagged it onto the obscure IDE report pile. It doesn't contain any
>>really useful information and its probably not an IDE layer bug as of
>>itself. But its on the todo list for further investigation and to see if
>>patterns emerge
>
>I shall give this a spin too, since I happen to have sis5513.


Just booted this fresh ata-enabled system (a matter of mkinitrd). It has 
not exploded yet.


	Jan
-- 
