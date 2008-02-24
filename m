Return-Path: <linux-kernel-owner+w=401wt.eu-S1757254AbYBXVJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254AbYBXVJv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 16:09:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753565AbYBXVJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 16:09:41 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:28335 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbYBXVJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 16:09:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=b9pn/4U96DsD92IDjCkChizbtCIZXaM19BxvlUQPVWUDJs5s2AGi7bnrebKVwWrT6zrV79MMp71vh+GsP/Uczx38V23gsVvKJK928lN0zxSENCYl4M/vGe2lKS5rDCsIhy3C5W9TR+cOgbGEinJlibHsXDowv7M/9H63yU29i+Y=
Date: Sun, 24 Feb 2008 22:09:32 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
Subject: [PATCH 0/3] Various IDE coding style fixes
Message-ID: <20080224220932.4098443e@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart,
three more patches, all are compile tested and against yesterday linux-next

"IDE: Replace __FUNCTION__ with __func__" depends 
on "IDE: Coding Style fixes to drivers/ide/ide-cd.c"


Paolo Ciarrocchi (3):
      IDE: Coding Style fixes to drivers/ide/ide-cd.c
      IDE: Replace __FUNCTION__ with __func__
      IDE: Coding Style fixes to drivers/ide/pci/cy82c693.c

 drivers/ide/ide-cd.c       |  259 +++++++++++++++++++++++---------------------
 drivers/ide/pci/cy82c693.c |   74 +++++++-------
 2 files changed, 171 insertions(+), 162 deletions(-)

Ciao,
              Paolo
