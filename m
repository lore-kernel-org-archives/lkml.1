Return-Path: <linux-kernel-owner+w=401wt.eu-S1759697AbYD2Waj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759697AbYD2Waj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 18:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754753AbYD2Wab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 18:30:31 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:47443 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754447AbYD2Wab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 18:30:31 -0400
Date: Wed, 30 Apr 2008 01:29:51 +0300
From: Adrian Bunk <bunk@kernel.org>
To: David Woodhouse <dwmw2@infradead.org>,
       Andres Salomon <dilinger@debian.org>
Cc: linux-kernel@vger.kernel.org
Subject: olpc_battery_trigger_uevent() is unused
Message-ID: <20080429222951.GB15987@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/power/olpc_battery.c:olpc_battery_trigger_uevent() is unused.

Should it have been used?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

