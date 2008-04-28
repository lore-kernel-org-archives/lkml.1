Return-Path: <linux-kernel-owner+w=401wt.eu-S936209AbYD1Pmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936209AbYD1Pmu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 11:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964885AbYD1Pje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 11:39:34 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:59607 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964876AbYD1Pjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 11:39:33 -0400
Date: Mon, 28 Apr 2008 18:39:00 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Jeremy Fitzhardinge <jeremy@xensource.com>, chrisw@sous-sol.org
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: drivers/xen/grant-table.c:gnttab_suspend() is unused
Message-ID: <20080428153900.GI2813@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/xen/grant-table.c:gnttab_suspend() is unused, and I have the gut 
feeling it should have been used.

Spotted by the GNU C compiler.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

