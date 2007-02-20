Return-Path: <linux-kernel-owner+w=401wt.eu-S965590AbXBTAH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965590AbXBTAH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750957AbXBTAHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:07:15 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:36032 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750939AbXBTAGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:06:48 -0500
Date: Tue, 20 Feb 2007 01:06:47 +0100
From: Adrian Bunk <bunk@stusta.de>
To: ak@suse.de
Cc: discuss@x86-64.org, linux-kernel@vger.kernel.org
Subject: x86_64: up to 255 or 256 CPUs?
Message-ID: <20070220000647.GI13958@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting arch/x86_64/Kconfig:

<--  snip  -->

...
config NR_CPUS
        int "Maximum number of CPUs (2-256)"
        range 2 255
...


<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

