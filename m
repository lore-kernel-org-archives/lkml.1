Return-Path: <linux-kernel-owner+w=401wt.eu-S1751240AbZDWLsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751240AbZDWLsy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 07:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755728AbZDWLsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 07:48:23 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:39239 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575AbZDWLsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 07:48:21 -0400
Message-Id: <20090423114638.865214111@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 23 Apr 2009 13:46:38 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 0/6] s390 patches for 2.6.30-rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,
another set of patches for s390. Patch #3 is the only one that
is not completely boring, it improves the quality of the idle
cpu accounting field in /proc/stat.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

