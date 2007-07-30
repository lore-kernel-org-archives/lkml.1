Return-Path: <linux-kernel-owner+w=401wt.eu-S966830AbXG3RJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966830AbXG3RJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 13:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761817AbXG3RJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 13:09:30 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:37197 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761504AbXG3RJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 13:09:29 -0400
Date: Mon, 30 Jul 2007 13:09:10 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 0/4] UML - Console cleanups
Message-ID: <20070730170910.GA7682@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These patches resulting from noticing a lot of cleanups needed in the
UML console system while fixing the previous spurious interrupt
testing.

There is one minor bug fix - a misordering of the error cleanups in
one of the drivers.

These are for 2.6.24.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
