Return-Path: <linux-kernel-owner+w=401wt.eu-S1755104AbXD2Kw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104AbXD2Kw4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 06:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755113AbXD2Kwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 06:52:55 -0400
Received: from mx1.suse.de ([195.135.220.2]:52024 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755093AbXD2Kwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 06:52:54 -0400
From: Andi Kleen <ak@suse.de>
Message-Id: <200704291252.514680000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [0/48] x86 candidate patches for review III: various stuff
Date: Sun, 29 Apr 2007 12:52:47 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


- Rewritten all dancing sched_clock()
- Extended numa emulation support from David Rientjes; now the sizes
of the emulated nodes can be configured on the command line.
- Faster vgettimeofday from Eric Dumazet
- GDT cleanups from Rusty
- cpa() fixes and better kernel protection from Jan Beulich
- PGD handling cleanup from Christoph Lameter
- Various other changes
- Lots of minor cleanups from various people

Please review.

-Andi

