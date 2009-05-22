Return-Path: <linux-kernel-owner+w=401wt.eu-S1757963AbZEVU2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963AbZEVU2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 16:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756930AbZEVU2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 16:28:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:65142 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756939AbZEVU2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 16:28:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,235,1241420400"; 
   d="scan'208";a="459730128"
Message-Id: <20090522202336.942728000@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 22 May 2009 13:23:36 -0700
From: venkatesh.pallipadi@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
       shaohua.li@intel.com,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [patch 0/2] x86: Misc bug fixes in pageattr.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Couple of misc bugfixes in pageattr.c found by looking at the code while
working on an unrelated patch.

-- 

