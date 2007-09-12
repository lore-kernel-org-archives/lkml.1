Return-Path: <linux-kernel-owner+w=401wt.eu-S971567AbXILSWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971567AbXILSWE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 14:22:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765667AbXILSVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 14:21:51 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:58226 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765168AbXILSVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 14:21:49 -0400
Date: Wed, 12 Sep 2007 20:21:48 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: patrizio.bassi@gmail.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       "Kernel," <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Alan Cox <alan@redhat.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Andi Kleen <ak@suse.de>,
       linux-acpi@vger.kernel.org
Subject: Re: libata not working for sis5533
In-Reply-To: <20070911154658.ab1fe162.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0709122018400.22467@fbirervta.pbzchgretzou.qr>
References: <46D132C5.5000803@gmail.com> <6bffcb0e0708261627s12e5a9acqef92d0261264a40c@mail.gmail.com>
 <46D8921E.3010304@gmail.com> <46D89429.7080802@gmail.com>
 <20070902114032.7dbfb21a@the-village.bc.nu>
 <Pine.LNX.4.64.0709031957390.24179@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0709061156220.25942@fbirervta.pbzchgretzou.qr>
 <46E26DAF.9020906@gmail.com> <Pine.LNX.4.64.0709081243050.25942@fbirervta.pbzchgretzou.qr>
 <46E3DA7E.7060709@gmail.com> <20070911154658.ab1fe162.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 11 2007 15:46, Andrew Morton wrote:
>Patrizio Bassi <patrizio.bassi@gmail.com> wrote:
>>Jan Engelhardt ha scritto:
>>>On Sep 8 2007 11:38, Patrizio Bassi wrote:
>>>>Jan Engelhardt wrote:
>>>>    
>>>>> I shall give this a spin too, since I happen to have sis5513. Just
>>>>> booted this fresh ata-enabled system (a matter of mkinitrd). It has not
>>>>> exploded yet.
>>>>>      
>>>> don't you have the "irq 14" issue?
>>>>    
>>> No, does not seem so.
>>
>> For Alan, libata devs...hope can help debug...
>> this is http://www.patriziobassi.it/downloads/libata_issue.jpg
>
>Looks more like a platform irq routing issue than an ata issue.
>
>Perhaps an x86 or an acpi person can help out with this.

Patrizio, have you tried with the old IDE? (And without suspend at that...)


	Jan
-- 
