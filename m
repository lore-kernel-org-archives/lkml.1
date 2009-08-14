Return-Path: <linux-kernel-owner+w=401wt.eu-S1756137AbZHNL33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbZHNL33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 07:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755825AbZHNL0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 07:26:42 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:65310 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755803AbZHNL0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 07:26:41 -0400
Message-Id: <20090814112517.982007860@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 14 Aug 2009 13:25:17 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 00/34] s390 patch queue for the merge window of 2.6.32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,
the current patch queue on git390 for the next merge window.
34 patches, most of it the usual churn: minor bug fixes too
big for 2.6.31-rc, various cleanups and two new things:
a patch to complete the extra kernel parameters via VMPARM
support introduced by git commit a0443fbb and the call home
features. Have fun.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

