Return-Path: <linux-kernel-owner+w=401wt.eu-S1754032AbYBWRib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbYBWRib (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 12:38:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbYBWRiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 12:38:19 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:58733 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbYBWRiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 12:38:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=vqaXdgQzhaPKhSNjt1IU2JA40AX9U7mot7J7X1igjln1HtUkGSaEIVyNqQ3eNDanue8sRKdzctDyuuq+OS7E/xy3DN/GXtkaLEi3laOAQZNsgLkg3kEl41oa+7F2aFJaJNiPuzmpx0ONerYQDLP7U32HvEdb0mofzoBJpWoXU4U=
Date: Sat, 23 Feb 2008 18:38:12 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
Subject: [PATCH 0/6] IDE: new series of Coding Style Fixes
Message-ID: <20080223183812.5af6d36d@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bart,
here is a new series of patches that remove some errors
and warnings reported by checkpatch.pl from the IDE subsystem.

All the patches have been compile tested and are against this morning (CET time :-)
linux-next

Paolo Ciarrocchi (6):
      IDE: Coding Style fixes to drivers/ide/pci/opti621.c
      IDE: Coding Style fixes to drivers/ide/legacy/hd.c
      IDE: Coding Style fixes to drivers/ide/legacy/ali14xx.c
      IDE: Coding Style fixes to drivers/ide/pci/it8213.c
      IDE: Coding Style fixes to drivers/ide/ide-floppy.c
      IDE: Coding Style fixes to drivers/ide/pci/cmd640.c

 drivers/ide/ide-floppy.c     |    4 +-
 drivers/ide/legacy/ali14xx.c |   11 +++--
 drivers/ide/legacy/hd.c      |   79 ++++++++++++++++++------------------
 drivers/ide/pci/cmd640.c     |   90 +++++++++++++++++++++---------------------
 drivers/ide/pci/it8213.c     |    9 ++--
 drivers/ide/pci/opti621.c    |   50 ++++++++++++------------
 6 files changed, 122 insertions(+), 121 deletions(-)

Ciao,
                Paolo
