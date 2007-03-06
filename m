Return-Path: <linux-kernel-owner+w=401wt.eu-S965995AbXCFSk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965995AbXCFSk6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 13:40:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965992AbXCFSk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 13:40:57 -0500
Received: from [198.99.130.12] ([198.99.130.12]:53026 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S965995AbXCFSk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 13:40:56 -0500
Message-Id: <200703061832.l26IW4iv006544@ccure.user-mode-linux.org>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.0.4
To: akpm@osdl.org
cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH 0/5] UML - hotplug fixes and cleanup
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Tue, 06 Mar 2007 13:32:03 -0500
From: Jeff Dike <jdike@addtoit.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These patches can wait till after 2.6.21.

Three of them are tidying patches of various sorts.  The other two fix
network interface and block device hotplug bugs.

				Jeff

