Return-Path: <linux-kernel-owner+w=401wt.eu-S1765040AbZD3TDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765040AbZD3TDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 15:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763009AbZD3TC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 15:02:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58140 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256AbZD3TC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 15:02:56 -0400
Message-Id: <20090430185628.866082445@arndb.de>
User-Agent: quilt/0.46-1
Date: Thu, 30 Apr 2009 20:56:28 +0200
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
       Remis Lima Baima <remis.developer@googlemail.com>
Subject: [PATCH v2 0/9] more non-ABI asm-generic headers
X-Provags-ID: V01U2FsdGVkX18Prgvahtl4qsAJ42s5mCY2UN4U5dqRestntRy
 S7DVJj06PCTTtSRWZMCcC5zXZskxQPN/mPaBvtYmnyM6yk/viK
 +E7gn+wn7NDC5642DM+xQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I reviewed my patches again after input from David Miller and
others, hopefully I have found a way to send out patches again.
This series is much smaller now, I consolidated some patches
according to logic grouping, and left out the microblaze
stuff, which is probably just boring everyone except Michal.

This should fix the broken From: and Date: headers in the
mail, which caused problems, while the contents are unchanged
from my earlier submission.

	Arnd <><


