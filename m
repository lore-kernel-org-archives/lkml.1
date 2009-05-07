Return-Path: <linux-kernel-owner+w=401wt.eu-S1761534AbZEGBsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761534AbZEGBsw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 21:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757961AbZEGBs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 21:48:27 -0400
Received: from mail.windriver.com ([147.11.1.11]:35228 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755636AbZEGBs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 21:48:27 -0400
From: Harry Ciao <qingtao.cao@windriver.com>
To: norsk5@yahoo.com, bluesmoke-devel@lists.sourceforge.net
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [v0 PATCH 0/1] EDAC: Use dev_name() for AMD8111/AMD8131 drivers
Date: Thu,  7 May 2009 09:47:37 +0800
Message-Id: <1241660858-21105-1-git-send-email-qingtao.cao@windriver.com>
X-Mailer: git-send-email 1.5.6.2
X-OriginalArrivalTime: 07 May 2009 01:47:08.0078 (UTC) FILETIME=[BB229CE0:01C9CEB5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Doug,

I found both the Makefile entries for AMD8111/AMD8131 EDAC entries 
are simply lost, and they are still referencing obsolete "bus_id" 
member of the device structure. 

Please help verify these issues again and help post this patch to 
the mm tree, thanks!

Best regards,

Harry
