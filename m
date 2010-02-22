Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab0BVP6I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 10:58:08 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35040 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463Ab0BVP6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 10:58:04 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 0/2] Make of_fdt conditionally compile gracefully
To: devicetree-discuss@lists.ozlabs.org, monstr@monstr.eu,
       linux-kernel@vger.kernel.org, jeremy.kerr@canonical.com
Date: Mon, 22 Feb 2010 08:50:48 -0700
Message-ID: <20100222154816.3604.67114.stgit@angua>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple more minor changes for cross-arch device tree support.

g.
---

Grant Likely (2):
      of/flattree: Make unflatten_device_tree() safe to call from any arch
      of/flattree: make of_fdt.h safe to unconditionally include.


 drivers/of/fdt.c       |   15 +++++++++++++++
 include/linux/of_fdt.h |    4 ++++
 2 files changed, 19 insertions(+), 0 deletions(-)

-- 
Signature
