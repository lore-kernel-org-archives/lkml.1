Return-Path: <linux-kernel-owner+w=401wt.eu-S1754984AbXGGULq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984AbXGGULq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 16:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbXGGULj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 16:11:39 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:53775 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752988AbXGGULi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 16:11:38 -0400
Date: Sat, 7 Jul 2007 22:12:08 +0200
From: Adrian Bunk <bunk@stusta.de>
To: spyro@f2s.com, john@dnsworld.co.uk
Cc: linux-kernel@vger.kernel.org
Subject: Status of the arm26 port?
Message-ID: <20070707201208.GJ3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm wondering what the status of the arm26 port in the kernel is:

AFAIR gcc support for this architecture was deprecated in gcc 3.4 and 
removed in gcc 4.0. This implies that either someone will have to re-add 
support to gcc in the next 1-2 years or the kernel port will become 
useless with the next increase of the minimum gcc requirement for the 
kernel.

The other point is that I tried to cross-compile an arm26 defconfig.
I gave up after running into several compile errors, and it doesn't seem 
as if any recent kernel could be compiled.

Is the arm26 kernel port already unused dead code or is some work for 
getting it back into shape pending?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

