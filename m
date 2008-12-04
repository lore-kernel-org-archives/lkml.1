Return-Path: <linux-kernel-owner+w=401wt.eu-S1759220AbYLDTJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759220AbYLDTJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 14:09:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756705AbYLDTJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 14:09:31 -0500
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:39091 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755613AbYLDTJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 14:09:30 -0500
Date: Fri, 5 Dec 2008 00:38:05 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Roland McGrath <roland@redhat.com>,
       akpm@linux-foundation.org, mingo@elte.hu, richardj_moore@uk.ibm.com,
       prasad@linux.vnet.ibm.com
Subject: [RFC Patch 0/9] Hardware Breakpoint interfaces - v2
Message-ID: <20081204190804.GA15134@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,
	Please find the latest set of patches that introduce kernel
interfaces to use Hardware Breakpoint registers and an implementation
for x86 (and x86_64) architecture.

The patches have undergone changes to incorporate the suggestions for
the previous patchset - including removal of support for instruction
breakpoint, and are based off 2.6.28-rc7. The patches have been tested
on x86 architecture along with kprobes, however they're posted as RFC
owing to the many pending tasks (refer
http://lkml.org/lkml/2008/10/7/127 for details).

Thanks,
K.Prasad

