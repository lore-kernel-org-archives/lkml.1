Return-Path: <linux-kernel-owner+w=401wt.eu-S1755830AbXGSJy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbXGSJy7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 05:54:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750864AbXGSJyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:54:46 -0400
Received: from ns2.suse.de ([195.135.220.15]:33021 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbXGSJyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:54:45 -0400
From: Andi Kleen <ak@suse.de>
Message-Id: <200707191154.642492000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [0/58] First batch of x86 patches for .23
Date: Thu, 19 Jul 2007 11:54:43 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


- Some more improvements for AMD family 10
- Some help for gcc 4.3
- Out of line string functions for i386 (saves >20k text) 
- x86-64 vDSO
- improved fake numa node code from David Rientjes
- various machine checking handling improvements from Tim H.
- timer cleanups and fixes from Thomas Gleixner
- various other cleanup and fixes

Please review. I plan to send them off relatively quickly
because I'm very late with this merge.

-Andi
