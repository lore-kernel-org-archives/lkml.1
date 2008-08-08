Return-Path: <linux-kernel-owner+w=401wt.eu-S1754821AbYHHA4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbYHHA4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 20:56:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbYHHA4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 20:56:47 -0400
Received: from relay2.sgi.com ([192.48.171.30]:50637 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751308AbYHHA4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 20:56:46 -0400
Message-Id: <20080808005639.505189000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 07 Aug 2008 17:56:39 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] SGI UV: Provide a LED driver and some System Activity Indicators
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Add a LED driver for UV systems and some functions to display system
activities such as when a CPU is active, and when a CPU is handling
timer interrupts.

Based on linux-2.6.tip/master.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>

-- 
