Return-Path: <linux-kernel-owner+w=401wt.eu-S1763860AbYDXUXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763860AbYDXUXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 16:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761617AbYDXUXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 16:23:45 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:55272 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758502AbYDXUXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 16:23:44 -0400
Date: Thu, 24 Apr 2008 23:22:57 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Matthias Schwarzott <zzam@gentoo.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: no help text for DVB_TUNER_ITD1000
Message-ID: <20080424202257.GC18854@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DVB_TUNER_ITD1000 option introduced by
commit 1881ee89e0fe03ac5bba9045acb3bea1818f9466
(V4L/DVB (7571): mt312: Cleanup buffer variables of read/write functions)
lacks a help text.

Please add a help text.

Thanks in advance
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

