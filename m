Return-Path: <linux-kernel-owner+w=401wt.eu-S1755245AbYBKMBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245AbYBKMBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 07:01:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbYBKMBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 07:01:15 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:57003 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315AbYBKMBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 07:01:14 -0500
Date: Mon, 11 Feb 2008 21:01:28 +0900 (JST)
Message-Id: <20080211.210128.108308594.anemo@mba.ocn.ne.jp>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/8] ide: add struct ide_port_info instances to legacy
 host drivers
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <200802110016.08078.bzolnier@gmail.com>
References: <20080211.010729.115910395.anemo@mba.ocn.ne.jp>
	<200802101804.49154.bzolnier@gmail.com>
	<200802110016.08078.bzolnier@gmail.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008 00:16:07 +0100, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> > It is too late for -git but not too late for 2.6.25-rc1. ;-)
> > 
> > Could you make a patch please?
> 
> I went ahead and made a patch (sorry, I needed it for git pull request :).
> 
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] ide: ide_init_port() bugfix

Thanks!  Looks sane for me :)

---
Atsushi Nemoto
