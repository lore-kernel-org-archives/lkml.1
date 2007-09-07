Return-Path: <linux-kernel-owner+w=401wt.eu-S965633AbXIGQAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965633AbXIGQAA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 12:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965527AbXIGP7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 11:59:43 -0400
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3240 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965497AbXIGP7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 11:59:41 -0400
Date: Fri, 7 Sep 2007 17:59:04 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sata & scsi suggestion for make menuconfig
Message-ID: <20070907155903.GR16806@vanheusden.com>
References: <20070907124800.GP16806@vanheusden.com> <20070907083522.3191a4ba.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070907083522.3191a4ba.randy.dunlap@oracle.com>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Reply-By: Fri Sep  7 11:31:04 CEST 2007
X-Message-Flag: www.unixexpert.nl
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Maybe it is a nice enhancement for make menuconfig to more explicitly
> > give a pop-up or so when someone selects for example a sata controller
> > while no 'scsi-disk' support was selected?
> 
> I know that it's difficult to get people to read docs & help text,
> and maybe it is needed in more places, but CONFIG_ATA (SATA/PATA)
> help text says:
>   NOTE: ATA enables basic SCSI support; *however*,
>   'SCSI disk support', 'SCSI tape support', or
>   'SCSI CDROM support' may also be needed,
>   depending on your hardware configuration.

Yes but that would mean that you have to open the help for each item
that you add.

> A popup makes some sense, but I don't know if menuconfig knows how to
> do popup warnings... and it needs to be done for all *configs,
> not just menuconfig.

Maybe add a new type?


Folkert van Heusden

-- 
MultiTail na wan makriki wrokosani fu tan luku den logfile nanga san
den commando spiti puru. Piki puru spesrutu sani, wroko nanga difreti
kroru, tja kon makandra, nanga wan lo moro.
http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
