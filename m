Return-Path: <linux-kernel-owner+w=401wt.eu-S1758830AbXIGWdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758830AbXIGWdU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 18:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753731AbXIGWdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 18:33:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:20120 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753988AbXIGWdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 18:33:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,222,1186383600"; 
   d="scan'208";a="274239551"
From: Jesse Barnes <jesse.barnes@intel.com>
To: linux-kernel@vger.kernel.org
Subject: Intel Memory Ordering White Paper
Date: Fri, 7 Sep 2007 15:26:50 -0700
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709071526.51169.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

FYI, we just released a new white paper describing memory ordering for 
Intel processors:
http://developer.intel.com/products/processor/manuals/index.htm

Should help answer some questions about some of the ordering primitives 
we use on i386 and x86_64.

Jesse
