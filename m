Return-Path: <linux-kernel-owner+w=401wt.eu-S932411AbXDEAiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411AbXDEAiW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 20:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932433AbXDEAiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 20:38:22 -0400
Received: from [198.99.130.12] ([198.99.130.12]:50392 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932411AbXDEAiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 20:38:21 -0400
Date: Wed, 4 Apr 2007 20:34:01 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [ PATCH 0/4] UML - Four for 2.6.22
Message-ID: <20070405003401.GA13290@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These four patches tidy code, improve debug output, and comment
pre-existing or pre-lacking locking.

They should wait for 2.6.22.

				Jeff
