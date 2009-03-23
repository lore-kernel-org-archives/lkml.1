Return-Path: <linux-kernel-owner+w=401wt.eu-S1756820AbZCWKnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbZCWKnG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 06:43:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756675AbZCWKmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 06:42:46 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34823 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756660AbZCWKmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 06:42:46 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 0/2] Series short description
To: linux-kernel@vger.kernel.org, rmk@arm.linux.org.uk
Date: Mon, 23 Mar 2009 10:43:42 +0000
Message-ID: <20090323103834.32524.65397.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix up a couple of leaks that were reported ages ago and forgotten about

---

Alan Cox (2):
      arm: fix leak in iop13xx/pci
      arm: twl4030 - leak fix


 arch/arm/mach-iop13xx/pci.c       |    5 ++++-
 arch/arm/mach-omap2/mmc-twl4030.c |    1 +
 2 files changed, 5 insertions(+), 1 deletions(-)

-- 
	"That was said by Eric Raymond who belongs to another movement" 
			- Richard Stallman

