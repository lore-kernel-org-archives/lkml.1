Return-Path: <linux-kernel-owner+w=401wt.eu-S1754313AbZD0JsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313AbZD0JsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 05:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753413AbZD0JsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 05:48:09 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:60685 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753391AbZD0JsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 05:48:08 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com
Subject: Microblaze MMU patches
Date: Mon, 27 Apr 2009 10:31:49 +0200
Message-Id: <1240821139-7247-1-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

here is the set of patches for supporting MMU for Microblaze.

This is the first submission to LKML.

All changes are available in next branch at 
git://git.monstr.eu/linux-2.6-microblaze.git .
gitweb - http://git.monstr.eu/git/gitweb.cgi?p=linux-2.6-microblaze.git;a=shortlog;h=refs/heads/next

I checked all patches with checkpatch.pl and there are some false-positive
issues. 

I'll update mmu_defconfig later.

Thanks for your time and review,
Michal


