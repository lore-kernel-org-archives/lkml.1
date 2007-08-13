Return-Path: <linux-kernel-owner+w=401wt.eu-S966107AbXHMRYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966107AbXHMRYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 13:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032468AbXHMRU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 13:20:26 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3224 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032462AbXHMRUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 13:20:22 -0400
Subject: RE: [PATCH] [21/2many] MAINTAINERS - AACRAID SCSI RAID DRIVER
From: Joe Perches <joe@perches.com>
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: torvalds@linux-foundation.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF01D12AA7@otce2k301.adaptec.com>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF01D12AA7@otce2k301.adaptec.com>
Content-Type: text/plain
Date: Mon, 13 Aug 2007 10:20:08 -0700
Message-Id: <1187025608.10249.141.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-13 at 10:16 -0400, Salyzyn, Mark wrote:
> Second thoughts ... Add the documentation file as well.
> +F:	Documentation/scsi/aacraid.txt

AACRAID SCSI RAID DRIVER
P:	Adaptec OEM Raid Solutions
M:	aacraid@adaptec.com
L:	linux-scsi@vger.kernel.org
W:	http://www.adaptec.com/
S:	Supported
F:	Documentation/scsi/aacraid.txt
F:	drivers/scsi/aacraid/

Maybe all 3 entries should be collapsed into

ADAPTEC SCSI RAID (AACRAID, DPT_I2O, IPS)?
P:	Adaptec OEM Raid Solutions
M:	aacraid@adaptec.com
L:	linux-scsi@vger.kernel.org
W:	http://www.adaptec.com/
S:	Supported
F:	Documentation/scsi/aacraid.txt
F:	drivers/scsi/aacraid/


