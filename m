Return-Path: <linux-kernel-owner+w=401wt.eu-S937624AbXGSNkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937624AbXGSNkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 09:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932550AbXGSNkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:40:18 -0400
Received: from khc.piap.pl ([195.187.100.11]:55992 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761579AbXGSNkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:40:16 -0400
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, ak@suse.de, adaplas@gmail.com,
       linux-fbdev-devel@lists.sourceforge.net, benh@kernel.crashing.org
Subject: Re: [git patches] two warning fixes
References: <20070718235504.GA9601@havoc.gtf.org>
	<alpine.LFD.0.999.0707181834070.27353@woody.linux-foundation.org>
	<469ECD29.2010909@garzik.org>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 19 Jul 2007 15:40:15 +0200
In-Reply-To: <469ECD29.2010909@garzik.org> (Jeff Garzik's message of "Wed, 18 Jul 2007 22:32:09 -0400")
Message-ID: <m3r6n4bjgg.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik <jeff@garzik.org> writes:

> My overall goal is killing useless warnings
> that continually obscure real ones.

Precisely, the goal should be to make must_check (and similar things)
warn only in real cases.
-- 
Krzysztof Halasa
