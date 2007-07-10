Return-Path: <linux-kernel-owner+w=401wt.eu-S1761047AbXGJKn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761047AbXGJKn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 06:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753308AbXGJKnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 06:43:18 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36021 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707AbXGJKnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 06:43:18 -0400
Date: Tue, 10 Jul 2007 16:22:40 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, menage@google.com, containers@lists.osdl.org
Subject: containers (was Re: -mm merge plans for 2.6.23)
Message-ID: <20070710105240.GA20914@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070710013152.ef2cd200.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 01:31:52AM -0700, Andrew Morton wrote:
> cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
> containersv10-basic-container-framework.patch
> containersv10-basic-container-framework-fix.patch
> containersv10-basic-container-framework-fix-2.patch
> containersv10-basic-container-framework-fix-3.patch
> containersv10-basic-container-framework-fix-for-bad-lock-balance-in-containers.patch
> containersv10-example-cpu-accounting-subsystem.patch
> containersv10-example-cpu-accounting-subsystem-fix.patch
> containersv10-add-tasks-file-interface.patch
> containersv10-add-tasks-file-interface-fix.patch
> containersv10-add-tasks-file-interface-fix-2.patch
> containersv10-add-fork-exit-hooks.patch
> containersv10-add-fork-exit-hooks-fix.patch
> containersv10-add-container_clone-interface.patch
> containersv10-add-container_clone-interface-fix.patch
> containersv10-add-procfs-interface.patch
> containersv10-add-procfs-interface-fix.patch
> containersv10-make-cpusets-a-client-of-containers.patch
> containersv10-make-cpusets-a-client-of-containers-whitespace.patch
> containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships.patch
> containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
> containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-cpuset-zero-malloc-fix-for-new-containers.patch
> containersv10-simple-debug-info-subsystem.patch
> containersv10-simple-debug-info-subsystem-fix.patch
> containersv10-simple-debug-info-subsystem-fix-2.patch
> containersv10-support-for-automatic-userspace-release-agents.patch
> containersv10-support-for-automatic-userspace-release-agents-whitespace.patch
> add-containerstats-v3.patch
> add-containerstats-v3-fix.patch
> update-getdelays-to-become-containerstats-aware.patch
> containers-implement-subsys-post_clone.patch
> containers-implement-namespace-tracking-subsystem-v3.patch
> 
>  Container stuff.  Hold, I guess.  I was expecting updates from Paul.

Paul,
	Are you working on a new version? I thought it was mostly ready
for mainline.

-- 
Regards,
vatsa
