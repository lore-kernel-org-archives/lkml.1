Return-Path: <linux-kernel-owner+w=401wt.eu-S1757387AbYA2FGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387AbYA2FGm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 00:06:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750778AbYA2FGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 00:06:31 -0500
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:34400 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbYA2FGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 00:06:30 -0500
From: Andi Kleen <ak@suse.de>
Message-Id: <20080129606.610336873@suse.de>
To: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH] [0/9] Latest GBPAGES patchkit for 2.6.25
Date: Tue, 29 Jan 2008 06:06:28 +0100 (CET)
X-OriginalArrivalTime: 29 Jan 2008 05:00:12.0252 (UTC) FILETIME=[D42B49C0:01C86233]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patchkit implements support for the 1GB pages of AMD Fam10h CPUs 
in the kernel direct mapping. 

Change to previous versions:
- Ported to latest change_page_attr
- kexec now works again
- Ported to latest git-x86
- Minor cleanups.

I believe this patchkit is ready for the 2.6.25 merge.

-Andi
