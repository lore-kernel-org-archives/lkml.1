Return-Path: <linux-kernel-owner+w=401wt.eu-S1755877AbXKLOk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877AbXKLOk4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 09:40:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753305AbXKLOkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 09:40:21 -0500
Received: from mtagate5.de.ibm.com ([195.212.29.154]:54610 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbXKLOkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 09:40:16 -0500
Message-Id: <20071112143009.425807965@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Mon, 12 Nov 2007 15:30:09 +0100
From: schwidefsky@de.ibm.com
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [patch 0/3] page table changes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,
more than 2 weeks have passed since I posted my six page table patches
to linux-kernel/linux-arch. Nobody complained so far (keeping fingers
crossed..) and Ben has a use for the first two patches on powerpc as
well. Next logical step would be to add the patches that affect common
code to the -mm tree, no?
The three patches in this patchset do apply against your snapshot
broken-out-2007-11-06-02-32.tar.gz. Please add.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

