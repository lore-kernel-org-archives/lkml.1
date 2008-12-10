Return-Path: <linux-kernel-owner+w=401wt.eu-S1757279AbYLJTou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279AbYLJTou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 14:44:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755681AbYLJTo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 14:44:27 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40458 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086AbYLJTo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 14:44:26 -0500
Message-Id: <20081210194048.464111787@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 10 Dec 2008 20:40:48 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, dhaval@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
       cfriesen@nortel.com
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 0/2] sched: task group weight interface
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Dhaval poked me that he (and others) didn't like the weight interface we
currently have for task groups. I concurr and dusted off these old patches.


-- 

