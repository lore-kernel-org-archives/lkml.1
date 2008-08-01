Return-Path: <linux-kernel-owner+w=401wt.eu-S1758246AbYHAUCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246AbYHAUCa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 16:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753618AbYHAUCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 16:02:23 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:39604 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753034AbYHAUCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 16:02:23 -0400
Subject: [PATCH 0/2] Cell OProfile: SPU mutex lock fix, version 4
From: Carl Love <cel@us.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@ozlabs.org,
       cel <cel@linux.vnet.ibm.com>, cbe-oss-dev@ozlabs.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 01 Aug 2008 13:01:14 -0700
Message-Id: <1217620874.15667.141.camel@carll-linux-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 1 is version 4 of the SPU mutex lock fix.

Patch 2 is a patch to fix an issue found in OProfile while implementing
version 4 of the SPU mutex lock fix.


