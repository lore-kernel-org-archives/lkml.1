Return-Path: <linux-kernel-owner+w=401wt.eu-S1946342AbXBQAqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946342AbXBQAqZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 19:46:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946344AbXBQAqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 19:46:25 -0500
Received: from [198.99.130.12] ([198.99.130.12]:42309 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1946342AbXBQAqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 19:46:24 -0500
Date: Fri, 16 Feb 2007 19:38:41 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Blaisorblade <blaisorblade@yahoo.it>
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [uml-devel] x86_64: fix 2.6.18 regression - PTRACE_OLDSETOPTIONS should be accepted
Message-ID: <20070217003841.GA9910@ccure.user-mode-linux.org>
References: <11715068631914-git-send-email-blaisorblade@yahoo.it> <200702152005.56594.blaisorblade@yahoo.it> <20070216190204.GB7481@ccure.user-mode-linux.org> <200702170104.36122.blaisorblade@yahoo.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702170104.36122.blaisorblade@yahoo.it>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 17, 2007 at 01:04:35AM +0100, Blaisorblade wrote:
> Which kernel? I've not yet tested 2.6.20. I'll try debugging this 
> subsequently.

2.6.20-rc6-mm3 on 2.6.20 + patches works for me.

					Jeff

-- 
Work email - jdike at linux dot intel dot com
