Return-Path: <linux-kernel-owner+w=401wt.eu-S1754718AbYB2EjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbYB2EjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 23:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754709AbYB2Eic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 23:38:32 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:52620 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438AbYB2Eia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 23:38:30 -0500
Message-Id: <20080229043242.110741439@linux.vnet.ibm.com>
User-Agent: quilt/0.45-1
Date: Fri, 29 Feb 2008 10:02:42 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: vatsa@linux.vnet.ibm.com, menage@google.com, balbir@linux.vnet.ibm.com,
       mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, skumar@linux.vnet.ibm.com
Subject: [patch 0/2] sched: cpuacct: minor cleanups and reset for cpuusage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset cleans up the cpuacct subsystem variable names and gives
the capability to reset the cpuusage variable for the group.

Thanks,
--
regards,
Dhaval

