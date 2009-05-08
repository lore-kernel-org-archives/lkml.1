Return-Path: <linux-kernel-owner+w=401wt.eu-S1762672AbZEHSS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762672AbZEHSS5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 14:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756770AbZEHSSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 14:18:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37925 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756488AbZEHSSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 14:18:04 -0400
Message-Id: <20090508165219.469818319@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 08 May 2009 18:52:19 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 0/5] pending patches
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first two cut down the tick overhead some.
The third ought to fix a problem Corey ran into.
The last two add some record data we talked about some time ago
but never got around to adding.

-- 

