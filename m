Return-Path: <linux-kernel-owner+w=401wt.eu-S1757966AbZETSoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966AbZETSoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 14:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755861AbZETSoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 14:44:09 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:6310 "EHLO
	IE1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228AbZETSoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 14:44:08 -0400
X-BigFish: VPS-3(zz4015Lzz1202hzzz32i62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KJYHD3-02-V41-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <akpm@linux-foundation.org>, <greg@kroah.com>, <mingo@elte.hu>
CC: <norsk5@yahoo.com>, <tglx@linutronix.de>, <hpa@zytor.com>,
       <mchehab@redhat.com>, <aris@redhat.com>, edt@aei.ca,
       <linux-kernel@vger.kernel.org>, randy.dunlap@oracle.com,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 0/4] amd64_edac: misc fixes
Date: Wed, 20 May 2009 20:43:53 +0200
Message-ID: <1242845037-1029-1-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.2.4
X-OriginalArrivalTime: 20 May 2009 18:43:58.0544 (UTC) FILETIME=[EF93AD00:01C9D97A]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here are some minor fixlets which came up lately. I'm sending them
separately as an offset from the rest of the patchset since nothing has
changed there. For details, see

git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git for-next

Thanks,
Boris.

