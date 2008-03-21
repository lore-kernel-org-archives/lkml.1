Return-Path: <linux-kernel-owner+w=401wt.eu-S1760992AbYCUU0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760992AbYCUU0r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 16:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754882AbYCUU0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 16:26:39 -0400
Received: from www.tglx.de ([62.245.132.106]:60817 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754806AbYCUU0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 16:26:38 -0400
Message-Id: <20080321200300.310393657@linutronix.de>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 20:26:10 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>, Randy Dunlap <randy.dunlap@oracle.com>
Subject: [patch 0/5] debugobject infrastructure V3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since V2:

- dropped the VM_USER check
- hash algorithm fixed
- processed Randy's documentation review
- added hrtimers (hrtimers have dynamic users now in the network code)

Thanks,

	tglx

-- 

