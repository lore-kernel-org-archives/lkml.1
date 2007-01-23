Return-Path: <linux-kernel-owner+w=401wt.eu-S932163AbXAWIbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163AbXAWIbn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 03:31:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932180AbXAWIbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 03:31:43 -0500
Received: from gate.perex.cz ([212.20.107.50]:34900 "EHLO gate.perex.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932163AbXAWIbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 03:31:43 -0500
Date: Tue, 23 Jan 2007 09:31:42 +0100 (CET)
From: Jaroslav Kysela <perex@suse.cz>
X-X-Sender: perex@tm8103.perex-int.cz
To: Linus Torvalds <torvalds@osdl.org>
Cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>
Subject: [ALSA PATCH] alsa-git merge request
Message-ID: <Pine.LNX.4.61.0701230931010.26861@tm8103.perex-int.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please do an update from:

  http://www.kernel.org/pub/scm/linux/kernel/git/perex/alsa.git
  (linus branch)

The GNU patch is available at:

  ftp://ftp.alsa-project.org/pub/kernel-patches/alsa-git-2007-01-23.patch.gz

The following files will be updated:

 sound/usb/usx2y/usbusx2yaudio.c |    2 +-
 sound/usb/usx2y/usx2yhwdeppcm.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


The following things were done:

Karsten Wiese (1):
      [ALSA] Repair snd-usb-usx2y over OHCI
