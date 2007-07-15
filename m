Return-Path: <linux-kernel-owner+w=401wt.eu-S1760959AbXGOMFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760959AbXGOMFA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 08:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758834AbXGOMEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 08:04:53 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:33810 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757072AbXGOMEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 08:04:52 -0400
Date: Sun, 15 Jul 2007 14:04:16 +0200
From: Adrian Bunk <bunk@stusta.de>
To: starvik@axis.com
Cc: dev-etrax@axis.com, linux-kernel@vger.kernel.org
Subject: cris port lacks a merge?
Message-ID: <20070715120415.GJ3565@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mikael,

the last maintainer update to arch/cris/ was two years ago and it seems 
code like e.g. the config variable ETRAX_ARCH_V32 is missing.

I assume there is there some external tree you use that contains updates?
If yes, can you submit the changes for inclusion into the upstream kernel?

TIA
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

