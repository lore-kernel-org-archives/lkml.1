Return-Path: <linux-kernel-owner+w=401wt.eu-S932785AbXDFUbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932785AbXDFUbZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 16:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932798AbXDFUbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 16:31:24 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:50896 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932785AbXDFUbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 16:31:24 -0400
Date: Fri, 6 Apr 2007 13:29:48 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       stable@kernel.org
Subject: Linux 2.6.20.6
Message-ID: <20070406202948.GU10574@sequoia.sous-sol.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.20.6 kernel.
This has 2 important fixes that should have been in 2.6.20.5.  They are
issues that were pointed with 2.6.20.5 patches during its review cycle,
but the patch updates were mistakenly dropped.  Please accept our
apologies for the mistake.

The diffstat and short summary of the fixes are below.

I'll also be replying to this message with a copy of the patch between
2.6.20.5 and 2.6.20.6.

The updated 2.6.20.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.20.y.git
and can be browsed at the normal kernel.org git web browser:
        www.kernel.org/git/

thanks,
-chris
--------

 Makefile                    |    2 +-
 crypto/scatterwalk.c        |    2 +-
 include/asm-um/common.lds.S |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

Summary of changes from v2.6.20.5 to v2.6.20.6
==============================================

Chris Wright (1):
      Linux 2.6.20.6

Herbert Xu (1):
      CRYPTO api: Use the right value when advancing scatterwalk_copychunks

Paolo 'Blaisorblade' Giarrusso (1):
      uml: fix static linking for real

