Return-Path: <linux-kernel-owner+w=401wt.eu-S1759253AbXK0Q3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759253AbXK0Q3c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 11:29:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758821AbXK0Q3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 11:29:22 -0500
Received: from mtagate8.de.ibm.com ([195.212.29.157]:17985 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756876AbXK0Q3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 11:29:21 -0500
Message-Id: <20071127162210.262064983@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 27 Nov 2007 17:22:10 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch 0/4] Latest patches for s390
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches have been added to the 2.6.24 queue:

Christian Borntraeger (2):
      [S390] dcssblk: prevent early access without own make_request function
      [S390] Fix compile error on 31bit without preemption

Cornelia Huck (1):
      [S390] cio: Issue SenseID per path.

Peter Oberparleiter (1):
      [S390] cio: add missing reprobe loop end statement

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

