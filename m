Return-Path: <linux-kernel-owner+w=401wt.eu-S1752079AbXHIV0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079AbXHIV0d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 17:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757512AbXHIV0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 17:26:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:37561 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757429AbXHIV0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 17:26:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,242,1183359600"; 
   d="scan'208";a="278946249"
Date: Thu, 9 Aug 2007 14:23:31 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: jeff@garzik.org
Cc: htejun@gmail.com, akpm@linux-foundation.org, arjan@linux.intel.com,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [patch 0/4] Updated SATA Link Power Management patches
Message-Id: <20070809142331.df657d05.kristen.c.accardi@intel.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
Here are some updated ALPM patches.  These patches are different from the
last version in that they now use the error handler to enable link power
management.  Please review and let me know what you think.

Kristen

-- 
