Return-Path: <linux-kernel-owner+w=401wt.eu-S1756244AbZKMPJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbZKMPJP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 10:09:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756168AbZKMPJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 10:09:09 -0500
Received: from mtagate7.de.ibm.com ([195.212.17.167]:41504 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097AbZKMPJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 10:09:01 -0500
Message-Id: <20091113150824.351347652@de.ibm.com>
User-Agent: quilt/0.48-1
Date: Fri, 13 Nov 2009 16:08:24 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 00/52] s390 patches for the next merge window (2.6.33)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,
the current patch queue on git390 for the next merge window.
52 patches, over half of them (27) are for the common-io-layer
rework. 6 patches for the optimization of the fault handler,
another 6 for the new cex3 crypto cards and some other stuff.
As always, have fun ..

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.
