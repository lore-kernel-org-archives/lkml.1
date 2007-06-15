Return-Path: <linux-kernel-owner+w=401wt.eu-S1752083AbXFOBEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbXFOBEZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 21:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751137AbXFOBER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 21:04:17 -0400
Received: from mx1.aecom.yu.edu ([129.98.1.51]:53464 "EHLO mx1.aecom.yu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbXFOBEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 21:04:16 -0400
X-AuditID: 816201a0-9f7cabb000001801-7e-4671e3e83020 
Mime-Version: 1.0
Message-Id: <a06240407c29791f67edd@[129.98.90.227]>
Date: Thu, 14 Jun 2007 21:03:39 -0400
To: linux-kernel@vger.kernel.org
From: Maurice Volaski <mvolaski@aecom.yu.edu>
Subject: What do the errors Invalid Phase Change and SYNC Offset Error mean
Cc: Eric.Moore@lsil.com, mpt_linux_developer@lsil.com
Content-Type: text/plain; charset="us-ascii" ; format="flowed"
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have an LSI Logic card attached to a RAID. The RAID occasionally 
reports SCSI bus resets,although that might be unrelated because I 
have other units of this RAID with the same complaint, but then this 
just recently was reported by the card:

Jun 14 19:19:51 [kernel] [86189.359115] mptbase: ioc0: 
LogInfo(0x110b0000): F/W: Invalid Phase Change
which repeated many times

and then

Jun 14 19:19:53 [kernel] [86191.654386] mptbase: ioc0: 
LogInfo(0x11040000): F/W: SYNC Offset Error
which repeated many times

There is also some white crud on the card surface, pictured here: 
http://www.fluxsoft.com/images/lsicrud.jpg

Any comments on what might be going on?
-- 

Maurice Volaski, mvolaski@aecom.yu.edu
Computing Support, Rose F. Kennedy Center
Albert Einstein College of Medicine of Yeshiva University
