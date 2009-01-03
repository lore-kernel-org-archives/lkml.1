Return-Path: <linux-kernel-owner+w=401wt.eu-S932842AbZACXYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932842AbZACXYQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 18:24:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760064AbZACXX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 18:23:59 -0500
Received: from styx.suse.cz ([82.119.242.94]:46200 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760007AbZACXX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 18:23:59 -0500
Date: Sun, 4 Jan 2009 00:23:56 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Nick Andrew <nick@nick-andrew.net>
cc: Trivial Kernel Patches <trivial@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [TRIVIAL PATCH 00/11] Fix misspelling of "firmware"
In-Reply-To: <20090103074923.27466.7287.stgit@marcab.local>
Message-ID: <alpine.LNX.1.10.0901040023070.5377@jikos.suse.cz>
References: <20090103074923.27466.7287.stgit@marcab.local>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Jan 2009, Nick Andrew wrote:

> Fix misspellings of "firmware" which I noticed in 2.6.28. All are 
> comment changes except for the change to drivers/scsi/qla4xxx/ql4_mbx.c 
> which is in a string argument to dev_info().
> 
> Nick.
> ---
> 
> Nick Andrew (11):
>       Fix misspelling of "firmware" in docs for ncr53c8xx/sym53c8xx
>       Fix misspelling of "firmware" in powerpc Makefile
>       Fix misspelling of "firmware" in usb.c
>       Fix misspelling of "firmware" in qla1280.c
>       Fix misspelling of "firmware" in a100u2w.c
>       Fix misspelling of "firmware" in megaraid.c
>       Fix misspelling of "firmware" in ql4_mbx.c
>       Fix misspelling of "firmware" in acpi_memhotplug.c
>       Fix misspelling of "firmware" in ipw2100.c
>       Fix misspelling of "firmware" in atmel.c
>       Fix misspelled firmware in Kconfig
> 
> 
>  Documentation/scsi/ChangeLog.ncr53c8xx |    2 +-
>  Documentation/scsi/ChangeLog.sym53c8xx |    2 +-
>  arch/powerpc/boot/Makefile             |    2 +-
>  drivers/acpi/acpi_memhotplug.c         |    2 +-
>  drivers/base/Kconfig                   |    2 +-
>  drivers/net/wireless/atmel.c           |    2 +-
>  drivers/net/wireless/ipw2100.c         |    2 +-
>  drivers/scsi/a100u2w.c                 |    2 +-
>  drivers/scsi/megaraid.c                |    4 ++--
>  drivers/scsi/qla1280.c                 |    4 ++--
>  drivers/scsi/qla4xxx/ql4_mbx.c         |    2 +-
>  drivers/uwb/i1480/dfu/usb.c            |    2 +-
>  12 files changed, 14 insertions(+), 14 deletions(-)

Thanks Nick, I have queued the patches in the trivial tree.

-- 
Jiri Kosina
SUSE Labs
