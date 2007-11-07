Return-Path: <linux-kernel-owner+w=401wt.eu-S1758744AbXKGShK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758744AbXKGShK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 13:37:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753608AbXKGSg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 13:36:57 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:60178 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578AbXKGSg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 13:36:57 -0500
Date: Wed, 7 Nov 2007 13:36:37 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 0/5] UML - Cleanups for 2.6.25
Message-ID: <20071107183637.GA8457@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These are code cleanups for 2.6.25, plus reverting a chunk of an
earlier patch which caused a warning I didn't notice at the time.

				Jeff
-- 
Work email - jdike at linux dot intel dot com
