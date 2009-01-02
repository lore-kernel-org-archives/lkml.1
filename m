Return-Path: <linux-kernel-owner+w=401wt.eu-S1757858AbZABQS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858AbZABQS5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 11:18:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756811AbZABQSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 11:18:48 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41358 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756755AbZABQSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 11:18:47 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 0/2] Series short description
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Fri, 02 Jan 2009 16:18:59 +0000
Message-ID: <20090102161825.18117.98501.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various i8k updates got lost but have now been chased up, signed off and
this adds them to the tree.
---

Andy Spencer (1):
      i8k: Enable i8k on Dell Precision Systems

Federico Heinz (1):
      i8k: Add Dell Vostro systems


 drivers/char/i8k.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

-- 
