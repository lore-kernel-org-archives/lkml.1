Return-Path: <linux-kernel-owner+w=401wt.eu-S932183AbXCXPqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183AbXCXPqI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 11:46:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932207AbXCXPqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 11:46:08 -0400
Received: from smtp21.orange.fr ([80.12.242.46]:44237 "EHLO smtp21.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932183AbXCXPqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 11:46:07 -0400
X-ME-UUID: 20070324154605340.532C91C00095@mwinf2129.orange.fr
Message-ID: <460547AA.80309@wanadoo.fr>
Date: Sat, 24 Mar 2007 16:45:46 +0100
From: Thibaud Hulin <hulin.thibaud@wanadoo.fr>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: error in compilation kernel 2.6.19 - internal compiler error
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello !

I'm triyng to compile the kernel 2.6.19 on Debian Testing 4.0
Unfortunately, I can't success.
This is my error message :

CC [M]  drivers/scsi/lpfc/lpfc_sli.o
In file included from drivers/scsi/lpfc/lpfc_sli.c:23:
include/linux/pci.h:251: internal compiler error: in build_int_cst_wide, 
at tree.c:803
Please submit a full bug report,
with preprocessed source if appropriate.
See <URL:http://gcc.gnu.org/bugs.html> for instructions.
For Debian GNU/Linux specific bug reporting instructions,
see <URL:file:///usr/share/doc/gcc-4.1/README.Bugs>.
The bug is not reproducible, so it is likely a hardware or OS problem.
make[4]: *** [drivers/scsi/lpfc/lpfc_sli.o] Erreur 1
make[3]: *** [drivers/scsi/lpfc] Erreur 2
make[2]: *** [drivers/scsi] Erreur 2
make[1]: *** [drivers] Erreur 2
make[1]: quittant le répertoire « /home/hulin/src_hitachi/linux-2.6.19 »
make: *** [debian/stamp-build-kernel] Erreur 2


Thanks for help,
Thibaud.

