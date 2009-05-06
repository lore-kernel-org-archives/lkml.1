Return-Path: <linux-kernel-owner+w=401wt.eu-S1760618AbZEFPO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760618AbZEFPO4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 11:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757001AbZEFPOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 11:14:47 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54958 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755975AbZEFPOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 11:14:47 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 0/2] Fix some free dereferences
To: torvalds@linux-foundation.org, mchehab@redhat.com,
       linux-kernel@vger.kernel.org
Date: Wed, 06 May 2009 17:12:59 +0100
Message-ID: <20090506161238.24311.27127.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---

Dan Carpenter (2):
      dereferencing freed in saa5249.c
      dereferencing freed in saa5246a.c


 drivers/media/video/saa5246a.c |    3 +--
 drivers/media/video/saa5249.c  |    4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)

-- 
Signature
