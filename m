Return-Path: <linux-kernel-owner+w=401wt.eu-S1759493AbYFOQPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759493AbYFOQPT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 12:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759064AbYFOQPD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 12:15:03 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:40784 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758911AbYFOQOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 12:14:46 -0400
Date: Sun, 15 Jun 2008 19:13:27 +0300
From: Adrian Bunk <bunk@kernel.org>
To: kyle@mcmartin.ca, matthew@wil.cx, grundler@parisc-linux.org
Cc: linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: parisc: pcibios_init_bus() isn't called
Message-ID: <20080615161327.GC7865@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/parisc/kernel/pci.c:pcibios_init_bus() never gets called - this
doesn't seem to be intentionally?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

