Return-Path: <linux-kernel-owner+w=401wt.eu-S1753377AbZKOQg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377AbZKOQg2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 11:36:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753351AbZKOQg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 11:36:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:45365 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325AbZKOQg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 11:36:26 -0500
Message-ID: <4B002DBE.3010307@kernel.org>
Date: Mon, 16 Nov 2009 01:35:10 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       lkml <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>
Subject: PULL request for linux-next
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Stephen.

Can you please pull the following tree into linux-next?

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-next

Currently, it only contains single patch from Thomas Gleixner to add
debugobject support in workqueue but I'm planning on pushing
concurrency managed workqueue patches through the above tree soonish.

Thank you very much.

-- 
tejun
