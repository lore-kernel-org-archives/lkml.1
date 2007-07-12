Return-Path: <linux-kernel-owner+w=401wt.eu-S1760501AbXGLHFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760501AbXGLHFn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 03:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbXGLHFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 03:05:36 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:40509 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422AbXGLHFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 03:05:35 -0400
Date: Thu, 12 Jul 2007 10:05:33 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: AHCI linkage error in 2.6.22+git
Message-ID: <Pine.SOC.4.64.0707121004410.18637@math>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trying to compile modular AHCI on ppc (prep):

  MODPOST 648 modules
ERROR: "ahci_port_resume" [drivers/ata/ahci.ko] undefined!

-- 
Meelis Roos (mroos@linux.ee)
