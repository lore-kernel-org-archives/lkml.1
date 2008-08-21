Return-Path: <linux-kernel-owner+w=401wt.eu-S1753158AbYHUErT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbYHUErT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 00:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbYHUErF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 00:47:05 -0400
Received: from gate.crashing.org ([63.228.1.57]:60651 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbYHUErF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 00:47:05 -0400
From: Kumar Gala <galak@kernel.crashing.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH 00/08] powerpc: Remove use of CONFIG_PPC_MERGE
Date: Wed, 20 Aug 2008 23:46:49 -0500
Message-Id: <1219294018-12557-1-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches remove Kconfig and code related to CONFIG_PPC_MERGE
and !CONFIG_PPC_MERGE.  There is some discussion about that one last
use of !PPC_MERGE with respect to the 4xx MTD_NAND_NDFC driver.

Subsystem maintainers how do you want to handle this, via the powerpc
tree of will you guys pick these up?

- k
