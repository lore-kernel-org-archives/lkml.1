Return-Path: <linux-kernel-owner+w=401wt.eu-S1752699AbZGWJ0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbZGWJ0a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 05:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbZGWJ0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 05:26:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46516 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400AbZGWJ03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 05:26:29 -0400
Date: Thu, 23 Jul 2009 11:26:29 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix typos "man[ae]g?ment" -> "management"
In-Reply-To: <1248330691-14941-1-git-send-email-u.kleine-koenig@pengutronix.de>
Message-ID: <alpine.LNX.2.00.0907231126090.11648@wotan.suse.de>
References: <alpine.LNX.2.00.0907230145120.11648@wotan.suse.de> <1248330691-14941-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="168427776-64285584-1248341189=:11648"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--168427776-64285584-1248341189=:11648
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Thu, 23 Jul 2009, Uwe Kleine-König wrote:

> ---
>  Documentation/DocBook/mtdnand.tmpl           |    2 +-
>  Documentation/DocBook/scsi.tmpl              |    2 +-
>  Documentation/scsi/ChangeLog.megaraid        |    2 +-
>  Documentation/sound/alsa/HD-Audio-Models.txt |    2 +-
>  Documentation/trace/ftrace.txt               |    2 +-
>  arch/arm/Makefile                            |    2 +-
>  arch/frv/lib/cache.S                         |    2 +-
>  arch/mn10300/include/asm/cacheflush.h        |    4 ++--
>  drivers/media/dvb/siano/smscoreapi.c         |    2 +-
>  drivers/media/dvb/siano/smscoreapi.h         |    4 ++--
>  drivers/media/radio/radio-mr800.c            |    2 +-
>  drivers/message/fusion/mptbase.c             |    4 ++--
>  drivers/net/macb.c                           |    2 +-
>  drivers/net/wireless/ath/ath5k/reg.h         |    2 +-
>  drivers/net/wireless/atmel.c                 |    2 +-
>  drivers/scsi/mpt2sas/mpt2sas_base.h          |    2 +-
>  drivers/scsi/mpt2sas/mpt2sas_scsih.c         |    4 ++--
>  drivers/usb/host/xhci.h                      |    2 +-
>  drivers/usb/wusbcore/wa-hc.h                 |    2 +-
>  include/linux/mISDNif.h                      |    2 +-
>  20 files changed, 24 insertions(+), 24 deletions(-)

Applied to trivial queue, thanks Uwe.

-- 
Jiri Kosina
SUSE Labs
--168427776-64285584-1248341189=:11648--
