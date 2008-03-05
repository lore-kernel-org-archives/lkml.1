Return-Path: <linux-kernel-owner+w=401wt.eu-S933104AbYCEL61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933104AbYCEL61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 06:58:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764712AbYCEL5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 06:57:23 -0500
Received: from mtagate1.de.ibm.com ([195.212.29.150]:57028 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935AbYCEL5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 06:57:19 -0500
Message-Id: <20080305115432.691030908@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 05 Mar 2008 12:54:32 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch 00/10] s390 bux fixes for 2.6.25-rc4.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assorted bug fixes for s390. The shortlog:

Christian Borntraeger (1):
      [S390] sclp_vt220: speed up console output for interactive work

Heiko Carstens (3):
      [S390] idle: Fix machine check handling in idle loop.
      [S390] Get rid of memcpy gcc warning workaround.
      [S390] Fix IPL from NSS.

Hongjie Yang (1):
      [S390] incorrect reipl nss name.

Martin Schwidefsky (1):
      [S390] Update default configuration.

Michael Holzheu (1):
      [S390] Load disabled wait psw if reipl fails.

Ralph Wuerthner (1):
      [S390] zcrypt: fix ap_device_list handling

Stefan Weinhuber (2):
      [S390] dasd: let dasd erp matching recognize alias recovery
      [S390] dasd: fix reference counting in display method for proc/dasd/devices

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.
