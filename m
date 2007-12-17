Return-Path: <linux-kernel-owner+w=401wt.eu-S934099AbXLQV5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934099AbXLQV5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 16:57:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757907AbXLQV4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 16:56:54 -0500
Received: from avexch1.qlogic.com ([198.70.193.115]:43084 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755454AbXLQV4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 16:56:53 -0500
Date: Mon, 17 Dec 2007 13:56:50 -0800
From: Andrew Vasquez <andrew.vasquez@qlogic.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Adaptec OEM Raid Solutions <aacraid@adaptec.com>,
       Andrew Vasquez <linux-driver@qlogic.com>,
       Brian King <brking@us.ibm.com>, Dave Jeffery <ipslinux@adaptec.com>,
       Hannes Reinecke <hare@suse.de>,
       "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
       James Smart <james.smart@emulex.com>,
       Mike Christie <michaelc@cs.wisc.edu>,
       Neela Syam Kolli <megaraidlinux@lsi.com>, linux-scsi@vger.kernel.org,
       open-iscsi@googlegroups.com
Subject: Re: [PATCH] drivers/scsi/: Spelling fixes
Message-ID: <20071217215650.GQ8520@plap3.qlogic.org>
References: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918893.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918893.git.joe@perches.com>
Organization: QLogic Corporation
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 17 Dec 2007 21:55:22.0450 (UTC) FILETIME=[85B6AB20:01C840F7]
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

qla2xxx bits:

Acked-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
