Return-Path: <linux-kernel-owner+w=401wt.eu-S1755116AbYJBRFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116AbYJBRFJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 13:05:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952AbYJBRE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 13:04:58 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:41967 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946AbYJBRE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 13:04:57 -0400
Subject: re: motherboard recommendations?
From: Kasper Sandberg <lkml@metanurb.dk>
To: Jacek Poplawski <jacekpoplawski@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1f276abf0809160657x4264ad5dm74fd2689d804a7ad@mail.gmail.com>
References: <1f276abf0809160657x4264ad5dm74fd2689d804a7ad@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 02 Oct 2008 19:04:56 +0200
Message-Id: <1222967096.25858.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-16 at 15:57 +0200, Jacek Poplawski wrote:
> Could you recommend motherboard which works perfecly stable with Linux?
> Last time I bought Asus K8V-X SE which was huge mistake - it has
> serious problems with AGP in Linux.

Appears to work fine for me on my K8V Deluxe and K8V SE Deluxe..

anyway, i have a gigabyte X48 DQ6 board.

the two realtek NIC's initially had problems, but fixes have been merged
and it works excellent. Audio works(not the two separate channels for
front), usb works, sensors work, ahci on both the jmicron and ICH works.
pata_jmicron works aswell.

> 
> Now I think about Intel chipset - P35 or P45.
> I want Asus, Gigabyte or MSI board with heat pipe.
> But I found another issue with audio and network drivers for Asus
> boards, so maybe I will skip Asus this time?
> 
> Which motherboard works stable for you?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

