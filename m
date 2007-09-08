Return-Path: <linux-kernel-owner+w=401wt.eu-S1753327AbXIHKpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbXIHKpp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 06:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbXIHKpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 06:45:35 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:36630 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbXIHKpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 06:45:34 -0400
Date: Sat, 8 Sep 2007 12:45:32 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Patrizio Bassi <patrizio.bassi@gmail.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       "Kernel," <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Alan Cox <alan@redhat.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: libata not working for sis5533
In-Reply-To: <46E26DAF.9020906@gmail.com>
Message-ID: <Pine.LNX.4.64.0709081243050.25942@fbirervta.pbzchgretzou.qr>
References: <46D132C5.5000803@gmail.com> <6bffcb0e0708261627s12e5a9acqef92d0261264a40c@mail.gmail.com>
 <46D8921E.3010304@gmail.com> <46D89429.7080802@gmail.com>
 <20070902114032.7dbfb21a@the-village.bc.nu>
 <Pine.LNX.4.64.0709031957390.24179@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0709061156220.25942@fbirervta.pbzchgretzou.qr>
 <46E26DAF.9020906@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 8 2007 11:38, Patrizio Bassi wrote:
>Jan Engelhardt wrote:
>>
>> I shall give this a spin too, since I happen to have sis5513.
>>
>> Just booted this fresh ata-enabled system (a matter of mkinitrd). It has 
>>not exploded yet.
>
>don't you have the "irq 14" issue?

No, does not seem so.

>can you post here your .config?

http://rafb.net/p/vfTX0966.html

Maybe it is solved in 2.6.22.3? (I don't remember what your version 
was.)


	Jan
-- 
