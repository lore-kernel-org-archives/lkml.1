Return-Path: <linux-kernel-owner+w=401wt.eu-S1764833AbYDYR5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764833AbYDYR5f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 13:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762704AbYDYR4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 13:56:53 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:53112 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762408AbYDYR4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 13:56:52 -0400
Date: Fri, 25 Apr 2008 13:55:59 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 0/19] UML - Cleanups and fixes for 2.6.26
Message-ID: <20080425175559.GA11172@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the stuff I have accumulated for 2.6.26.  Cleanups and fixes of
varying sizes.

Patch 8 fiddles the includes of a bunch of the asm/futex.h's, so isn't
UML-specific.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
