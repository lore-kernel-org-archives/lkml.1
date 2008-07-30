Return-Path: <linux-kernel-owner+w=401wt.eu-S1756704AbYG3Ssq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704AbYG3Ssq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 14:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753076AbYG3Ssh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 14:48:37 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:33624 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbYG3Ssg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 14:48:36 -0400
Date: Wed, 30 Jul 2008 13:48:33 -0500
From: Mike Miller <mike.miller@hp.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML-scsi <linux-scsi@vger.kernel.org>
Subject: Problems building 2.6.26 and 2.6.27-rc1
Message-ID: <20080730184833.GA936@roadking.ldev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.9i
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm getting the following error when trying to build either 2.6.26 or
2.6.27-rc1:

arch/x86/kernel/head64.c: In function ‘x86_64_start_kernel’:
arch/x86/kernel/head64.c:88: error: size of array ‘type name’ is negative

Systems I've tried are DL585 G5 with dual-core Opterons and ML370 G5 with
dual-core Intel. Both were originally installed using an x86_64 distro.

Anybody else seen this? Any workarounds?

Thanks,
mikem
