Return-Path: <linux-kernel-owner+w=401wt.eu-S1758958AbYEEMr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758958AbYEEMr6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 08:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755938AbYEEMrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 08:47:46 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:56206 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754137AbYEEMrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 08:47:46 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca
Subject: Microblaze patches V2
Date: Sun,  4 May 2008 13:40:49 +0200
Message-Id: <1209901305-6404-1-git-send-email-monstr@seznam.cz>
X-Mailer: git-send-email 1.5.4.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

this is second set of patches. I fixed almost all bugs which
were reported in your emails.

As you know we are fixing syscall table and files related with it.
Please don't report bugs there.

Please send me all your suggestions.

I would like to catch 2.6.27. Please report all future bugs which can arise with it.

All changes are available on git.monstr.eu.

Thanks for your review,
Michal Simek


