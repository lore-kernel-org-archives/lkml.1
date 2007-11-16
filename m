Return-Path: <linux-kernel-owner+w=401wt.eu-S933523AbXKPOdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933523AbXKPOdm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 09:33:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758217AbXKPOdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 09:33:24 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:54991 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbXKPOdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 09:33:22 -0500
Message-Id: <20071116142942.978412023@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 16 Nov 2007 15:29:42 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch 0/6] Pending patches in the s390 2.6.25 merge queue.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The current set of patches queue for the next merge window with more
to come. The shortlog:

Heiko Carstens (3):
      [S390] sclp: call sclp_init() from start_kernel().
      [S390] Standby cpu activation/deactivation.
      [S390] sclp: convert channel path configure code to use sync interface.

Michael Ernst (1):
      [S390] sclp: sysfs interface for SCLP cpi

Michael Holzheu (1):
      [S390] kernel: Shutdown Actions Interface

Peter Oberparleiter (1):
      [S390] cio: Extend adapter interrupt interface.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

