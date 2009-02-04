Return-Path: <linux-kernel-owner+w=401wt.eu-S1758679AbZBDTtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758679AbZBDTtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 14:49:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755005AbZBDTsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 14:48:51 -0500
Received: from smtp5.welho.com ([213.243.153.39]:49880 "EHLO smtp5.welho.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491AbZBDTsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 14:48:51 -0500
Date: Wed, 4 Feb 2009 21:48:51 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Balaji Rao <balajirrao@openmoko.org>, Andy Green <andy@openmoko.com>,
       Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org
Subject: mfd/pcf50633-gpio.c is completely unused
Message-ID: <20090204194844.GA26138@localhost.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm wondering:

Is any user for the code in drivers/mfd/pcf50633-gpio.c pending, or did 
something go wrong when merging it?

Currently it is completely unused.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

