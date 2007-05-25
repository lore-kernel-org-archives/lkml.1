Return-Path: <linux-kernel-owner+w=401wt.eu-S1760890AbXEYIhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760890AbXEYIhq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 04:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759914AbXEYIhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 04:37:32 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:40486 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758539AbXEYIha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 04:37:30 -0400
Message-Id: <20070525083607.784351000@sonycom.com>
User-Agent: quilt/0.46-1
Date: Fri, 25 May 2007 10:36:07 +0200
From: Geert.Uytterhoeven@sonycom.com
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [patch 0/7] RFC: PS3 Storage Drivers
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi,

This is the first submission of the new PS3 storage drivers:
 [1] ps3: Preallocate bootmem memory for the PS3 FLASH ROM storage driver
 [2] ps3: Extract ps3_repository_find_bus()
 [3] ps3: Storage Driver Core
 [4] ps3: Storage Driver Probing
 [5] ps3: Disk Storage Driver
 [6] ps3: ROM Storage Driver
 [7] ps3: FLASH ROM Storage Driver

They are submitted purely for review, as some of the underlying infrastructure
code hasn't been submitted yet (for reference, you can take a look at Geoff's
git tree (git://git.kernel.org/pub/scm/linux/kernel/git/geoff/ps3-linux.git)).

Thanks for you comments!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium

