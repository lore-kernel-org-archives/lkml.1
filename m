Return-Path: <linux-kernel-owner+w=401wt.eu-S1753688AbXEFB0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688AbXEFB0e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 21:26:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753678AbXEFB0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 21:26:34 -0400
Received: from dialup.esmr.ru ([85.94.3.83]:57936 "EHLO localhost.localdomain"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753089AbXEFB0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 21:26:33 -0400
From: Vitaly Bordug <vitb@kernel.crashing.org>
To: linux-pcmcia@lists.infradead.org
Cc: linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org
Subject: [PATCH 0/2] of_device 8xx PCMCIA support && cleanup
Date: Sun, 06 May 2007 05:26:08 +0400
Message-ID: <20070506011004.12695.41514.stgit@localhost.localdomain>
User-Agent: StGIT/0.11
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Current series features the reworked  8xx of_device PCMCIA patch
based on feedback from Andrew + indentation & whitespace fixes
in drivers/pcmcia/m8xx_pcmcia.c

Andrew,
Please disregard previous patch since it contains a typo. Indentation 
patch is not strictly necessary but is useful too, imho.

--
-Vitaly
