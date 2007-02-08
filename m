Return-Path: <linux-kernel-owner+w=401wt.eu-S1945911AbXBHWEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945911AbXBHWEl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 17:04:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945915AbXBHWEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 17:04:41 -0500
Received: from [198.99.130.12] ([198.99.130.12]:39074 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1945911AbXBHWEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 17:04:40 -0500
Message-Id: <200702082157.l18LvSun007592@ccure.user-mode-linux.org>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.0.4
To: akpm@osdl.org
cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH 0/3] UML bug fixes
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Thu, 08 Feb 2007 16:57:27 -0500
From: Jeff Dike <jdike@addtoit.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These are 2.6.21 material.  They fix real bugs in early error reporting,
x86_64 thread and ptrace support.

				Jeff

