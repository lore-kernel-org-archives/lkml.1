Return-Path: <linux-kernel-owner+w=401wt.eu-S1755307AbYFCRF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbYFCRF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 13:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbYFCRFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 13:05:46 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:40298 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbYFCRFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 13:05:45 -0400
Message-Id: <20080603165859.107949986@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 03 Jun 2008 18:58:59 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch 00/14] s390 feature patches for 2.6.27.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,
these are the patches that are currently on my queue for the merge
window of 2.6.27:

Cornelia Huck (6):
      [S390] cio: Register all subchannels.
      [S390] cio: Introduce modalias for css bus.
      [S390] cio: Rework css driver.
      [S390] cio: Cleanup crw interface.
      [S390] cio: Export some symbols for modular css drivers.
      [S390] cio: Base message subchannel handling.

Heiko Carstens (1):
      [S390] initrd vs bss section clearing.

Martin Schwidefsky (2):
      [S390] Introduce user_regset accessors for s390
      [S390] stp support.

Peter Oberparleiter (4):
      [S390] cio: introduce fcx bit to chsc characteristics
      [S390] cio: introduce fcx enabled scsw format
      [S390] cio: provide functions for fcx enabled I/O
      [S390] cio: provide helper functions for fcx enabled I/O

Sebastian Ott (1):
      [S390] cio: remove lock from ccw_device_oper_notify.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

