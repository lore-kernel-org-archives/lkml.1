Return-Path: <linux-kernel-owner+w=401wt.eu-S1757753AbYDUSnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753AbYDUSnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 14:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753719AbYDUSnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 14:43:13 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:41566
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752225AbYDUSnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 14:43:13 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 0/2] sched: refreshes
To: mingo@elte.hu
Cc: suresh.b.siddha@intel.com, rostedt@goodmis.org, chinang.ma@intel.com,
       arjan@linux.intel.com, willy@linux.intel.com, ghaskins@novell.com,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Date: Mon, 21 Apr 2008 14:10:10 -0400
Message-ID: <20080421180747.4560.67794.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,
  Here is a refresh of the two patches you asked for:

#1 is "v3" of the "pushed" patch which fixes the compilation issue on
 !CONFIG_SMP

#2 is a resend of the 2-d bitmap, which includes a fix for that typo I
 mentioned.

Regards,
-Greg
