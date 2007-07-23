Return-Path: <linux-kernel-owner+w=401wt.eu-S1759865AbXGWIxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759865AbXGWIxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 04:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755471AbXGWIxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 04:53:41 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:37780 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331AbXGWIxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 04:53:40 -0400
Message-Id: <20070723084548.394178614@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Mon, 23 Jul 2007 10:45:48 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch 0/9] s390 update for 2.6.23-rc1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The shortlog speaks for itself:

Christian Borntraeger (1):
      [S390] add types.h include to s390_ext.h

Cornelia Huck (3):
      [S390] cio: css_sch_device_register() can be made static.
      [S390] cio: Remove remains of _ccw_device_get_device_number().
      [S390] cio: Remove deprecated rdc/rcd.

Heiko Carstens (4):
      [S390] Convert to smp_call_function_single.
      [S390] Improve __smp_call_function_map.
      [S390] sclp: kill unused SCLP config option.
      [S390] Get rid of new section mismatch warnings.

Martin Schwidefsky (1):
      [S390] Wire up sys_fallocate.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

