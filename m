Return-Path: <linux-kernel-owner+w=401wt.eu-S1754110AbYEPIDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbYEPIDP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 04:03:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750990AbYEPICv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 04:02:51 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:55578 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbYEPICt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 04:02:49 -0400
Date: Fri, 16 May 2008 11:01:03 +0300
From: Adrian Bunk <bunk@kernel.org>
To: rmk@arm.linux.org.uk, sjhill@cotw.com
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC: 2.6 patch] remove drivers/acorn/char/defkeymap-l7200.c
Message-ID: <20080516080102.GN1936@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="VywGB/WGlW4DM4P8"
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VywGB/WGlW4DM4P8
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

The config option for building drivers/acorn/char/defkeymap-l7200.c is
not present since at least kernel 2.6.0.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

To avoid charset problems this patch is attached compressed.

This patch has been sent on:
- 22 Apr 2008
- 14 Apr 2008
- 31 Mar 2008

 arch/arm/Makefile                    |    2 
 drivers/acorn/char/Makefile          |    5 
 drivers/acorn/char/defkeymap-l7200.c |  386 ---------------------------
 3 files changed, 393 deletions(-)


--VywGB/WGlW4DM4P8
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="patch-remove-defkeymap-l7200.gz"
Content-Transfer-Encoding: base64

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

--VywGB/WGlW4DM4P8--
