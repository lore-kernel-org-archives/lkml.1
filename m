Return-Path: <linux-kernel-owner+w=401wt.eu-S1754735AbYHAQoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735AbYHAQoh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 12:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbYHAQo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 12:44:26 -0400
Received: from gate.crashing.org ([63.228.1.57]:50613 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712AbYHAQo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 12:44:26 -0400
From: Kumar Gala <galak@kernel.crashing.org>
To: linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/10] powerpc: Remove use of CONFIG_PPC_MERGE
Date: Fri,  1 Aug 2008 11:44:10 -0500
Message-Id: <1217609060-6381-1-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches remove Kconfig and code related to CONFIG_PPC_MERGE
and !CONFIG_PPC_MERGE.  There is some discussion about that one last
use of !PPC_MERGE with respect to the 4xx MTD_NAND_NDFC driver.

Paul, is this something you'd be willing to entertain for 2.6.27?

- k
