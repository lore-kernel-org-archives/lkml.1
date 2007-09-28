Return-Path: <linux-kernel-owner+w=401wt.eu-S1755148AbXI1L5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbXI1L5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 07:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752208AbXI1L5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 07:57:14 -0400
Received: from tidos.tid.es ([193.145.240.2]:53325 "EHLO correo.tid.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726AbXI1L5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 07:57:14 -0400
X-Greylist: delayed 3601 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Sep 2007 07:57:13 EDT
Date: Fri, 28 Sep 2007 12:56:46 +0200
From: Miguel <mc354@tid.es>
Subject: software unplug and plug USB
To: lkml <linux-kernel@vger.kernel.org>
Message-id: <1190977006.10424.6.camel@McM>
MIME-version: 1.0
X-Mailer: Evolution 2.10.1
Content-type: text/plain
Content-transfer-encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

I'm using a huawei E220 modem and occasionally it doesn't work and I
must unplug and plug it again, run the scripts connection to make it
works again.
how can I unplug an plug an USB modem via software?

The other problem is that this device is recognized like a cd rom
although I have patch my kernel 2.6.17. here is the var/messages:


Sep 28 12:53:41 ecar kernel: [17179613.972000]   Vendor: HUAWEI
Model: Mass Storage      Rev: 2.31
Sep 28 12:53:41 ecar kernel: [17179613.972000]   Type:   CD-ROM
ANSI SCSI revision: 02
Sep 28 12:53:41 ecar kernel: [17179613.996000] sr0: scsi3-mmc drive:
65x/349x xa/form2 cdda tray
Sep 28 12:53:41 ecar kernel: [17179613.996000] Uniform CD-ROM driver
Revision: 3.20


could anybody help me?

regards,

mike


