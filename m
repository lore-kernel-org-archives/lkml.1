Return-Path: <linux-kernel-owner+w=401wt.eu-S1758027AbZJDUtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027AbZJDUtP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 16:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757933AbZJDUtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 16:49:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42843 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757928AbZJDUtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 16:49:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [Bug #14256] kernel BUG at fs/ext3/super.c:435
Date: Sun, 4 Oct 2009 22:49:54 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc2-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <COE24pZSBH.A.ot.9MTxKB@chimera> <19144.56721.786457.979953@pilspetsen.it.uu.se>
In-Reply-To: <19144.56721.786457.979953@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910042249.54639.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 October 2009, Mikael Pettersson wrote:
> Rafael J. Wysocki wrote:
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D14256
> > Subject		: kernel BUG at fs/ext3/super.c:435
> > Submitter	: Mikael Pettersson <mikpe@it.uu.se>
> > Date		: 2009-09-21 7:29 (11 days old)
> > References	: http://marc.info/?l=3Dlinux-kernel&m=3D125351816109264&w=3D4
> 
> The exact same bug (same cause, same symptom) just hit me again in 2.6.32-rc1.

Thanks for the update.

Could you check the current Linus' tree, please?  There are some known
regression fixes in there.

Best,
Rafael
