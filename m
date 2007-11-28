Return-Path: <linux-kernel-owner+w=401wt.eu-S1759118AbXK1TFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759118AbXK1TFR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 14:05:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754603AbXK1TFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 14:05:04 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:42871 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992AbXK1TFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 14:05:01 -0500
Date: Wed, 28 Nov 2007 14:04:37 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 0/4] UML - Fixes for 2.6.24
Message-ID: <20071128190437.GA8318@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These four patches should go into 2.6.24.  There are two build fixes,
a fix for yesterday's NO_HZ patch, and a workaround for a host bug.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
