Return-Path: <linux-kernel-owner+w=401wt.eu-S1756014AbZEUOAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbZEUOAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 10:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbZEUOAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 10:00:23 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:57486 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810AbZEUOAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 10:00:22 -0400
Date: Thu, 21 May 2009 19:30:20 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [Patch 00/12] Hardware Breakpoint interfaces
Message-ID: <20090521140020.GA13849@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,
	Please find the patchset that introduces generic Hardware Breakpoint
interfaces and an implementation for x86/x86_64 architecture.

In this iteration, the patches for HW Breakpoint interfaces sent here:
http://lkml.org/lkml/2009/5/15/139 have been combined with patches containing
improvements and minor fixes (posted here: http://lkml.org/lkml/2009/5/19/264)
for easy integration into -tip tree.

Kindly accept the same.

Thanks,
K.Prasad

