Return-Path: <linux-kernel-owner+w=401wt.eu-S1758727AbYHSXY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727AbYHSXY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 19:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755973AbYHSXW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 19:22:58 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:52140 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755957AbYHSXW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 19:22:56 -0400
Message-Id: <20080819232232.432973784@us.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 19 Aug 2008 16:22:32 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Paul Menage <menage@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-pm@lists.linux-foundation.org
Subject: [PATCH 0/6] Container Freezer: fixes for -mm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

	These patches stack on top of the series you already have for the
container freezer patches. I believe they address all of the comments from
you and Rafael so far. 

	Please consider these for -mm.

[PATCH 1/6] Container Freezer: Fix freezer Kconfig
[PATCH 2/6] Container Freezer: uninline thaw_process()
[PATCH 3/6] Container Freezer: Make freezer state names less generic
[PATCH 4/6] Container Freezer: Cleanup comment
[PATCH 5/6] Container Freezer: Rename check_if_frozen()
[PATCH 6/6] Container Freezer: Document the cgroup freezer subsystem

Cheers,
	-Matt Helsley

-- 
