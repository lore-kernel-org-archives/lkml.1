Return-Path: <linux-kernel-owner+w=401wt.eu-S1751738AbXBVRvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738AbXBVRvA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 12:51:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751742AbXBVRvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 12:51:00 -0500
Received: from [198.99.130.12] ([198.99.130.12]:34977 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbXBVRu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 12:50:59 -0500
Date: Thu, 22 Feb 2007 12:42:56 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Blaisorblade <blaisorblade@yahoo.it>
Cc: user-mode-linux-devel@lists.sourceforge.net, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [uml-devel] [PATCH 4/4] UML - lock host ldt retrieval
Message-ID: <20070222174256.GE3396@ccure.user-mode-linux.org>
References: <200702212025.l1LKPKRm006789@ccure.user-mode-linux.org> <200702212340.28900.blaisorblade@yahoo.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702212340.28900.blaisorblade@yahoo.it>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 11:40:28PM +0100, Blaisorblade wrote:
> Please remove GFP_KERNEL allocation under spin_lock

Nice spotting - I'll redo the patch.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
