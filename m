Return-Path: <linux-kernel-owner+w=401wt.eu-S1764783AbXGYXAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764783AbXGYXAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 19:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759594AbXGYXAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 19:00:47 -0400
Received: from main.carme.maven.pl ([193.239.45.138]:10523 "EHLO
	main.carme.maven.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759AbXGYXAq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 19:00:46 -0400
From: Arkadiusz Miskiewicz <arekm@maven.pl>
Organization: SelfOrganizing
To: linux-kernel@vger.kernel.org
Subject: very big device. try to use READ CAPACITY(16)
Date: Thu, 26 Jul 2007 01:00:38 +0200
User-Agent: PLD Linux KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707260100.38632.arekm@maven.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

What does "very big device. try to use READ CAPACITY(16)" mean for user? Is 
this advice for driver developer or for user (if for user then what does it 
mean exactly) ?


sdc : very big device. try to use READ CAPACITY(16).
SCSI device sdc: 4823210240 512-byte hdwr sectors (2469484 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 12 00 00
SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
sdc : very big device. try to use READ CAPACITY(16).
SCSI device sdc: 4823210240 512-byte hdwr sectors (2469484 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 12 00 00
SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
 sdc: unknown partition table
sd 0:2:0:0: Attached scsi disk sdc

2.6.21.6, stex driver

-- 
Arkadiusz Mi¶kiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
