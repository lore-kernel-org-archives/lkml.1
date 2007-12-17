Return-Path: <linux-kernel-owner+w=401wt.eu-S932764AbXLQWGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932764AbXLQWGN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 17:06:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758224AbXLQWFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 17:05:55 -0500
Received: from emulex.emulex.com ([138.239.112.1]:39153 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755628AbXLQWFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 17:05:54 -0500
Message-ID: <4766F2B5.9010105@emulex.com>
Date: Mon, 17 Dec 2007 17:05:41 -0500
From: James Smart <James.Smart@Emulex.Com>
Reply-To: James.Smart@Emulex.Com
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
CC: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Adaptec OEM Raid Solutions <aacraid@adaptec.com>,
       Andrew Vasquez <linux-driver@qlogic.com>,
       Brian King <brking@us.ibm.com>, Dave Jeffery <ipslinux@adaptec.com>,
       Hannes Reinecke <hare@suse.de>,
       "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
       Mike Christie <michaelc@cs.wisc.edu>,
       Neela Syam Kolli <megaraidlinux@lsi.com>, linux-scsi@vger.kernel.org,
       open-iscsi@googlegroups.com
Subject: Re: [PATCH] drivers/scsi/: Spelling fixes
References: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918893.git.joe@perches.com> <20071217215650.GQ8520@plap3.qlogic.org>
In-Reply-To: <20071217215650.GQ8520@plap3.qlogic.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Dec 2007 22:05:43.0257 (UTC) FILETIME=[F7BE4C90:01C840F8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 17 Dec 2007, Joe Perches wrote:

> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/scsi/NCR53C9x.h               |    2 +-
>  drivers/scsi/aic7xxx/aic79xx_inline.h |    2 +-
>  drivers/scsi/aic7xxx/aic79xx_osm.c    |    2 +-
>  drivers/scsi/aic7xxx/aic79xx_pci.c    |    4 ++--
>  drivers/scsi/aic7xxx/aic7xxx_inline.h |    2 +-
>  drivers/scsi/aic7xxx/aic7xxx_osm.c    |    2 +-
>  drivers/scsi/ipr.c                    |    2 +-
>  drivers/scsi/ips.c                    |    2 +-
>  drivers/scsi/iscsi_tcp.c              |    4 ++--
>  drivers/scsi/lpfc/lpfc.h              |    2 +-
>  drivers/scsi/lpfc/lpfc_mbox.c         |    2 +-
>  drivers/scsi/megaraid/megaraid_mbox.c |   10 +++++-----
>  drivers/scsi/psi240i.c                |    2 +-
>  drivers/scsi/qla2xxx/qla_gs.c         |    2 +-

For the lpfc bits:

Acked-by: James Smart <james.smart@emulex.com>

