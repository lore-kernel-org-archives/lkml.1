Return-Path: <linux-kernel-owner+w=401wt.eu-S1755615AbZFZCsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615AbZFZCsg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 22:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbZFZCs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 22:48:28 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:49972 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbZFZCs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 22:48:28 -0400
Date: Thu, 25 Jun 2009 22:48:02 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>,
       Boaz Harrosh <bharrosh@panasas.com>, Paul Menage <menage@google.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] [PATCH] UML: Fix some apparent bitrot
Message-ID: <20090626024802.GA17655@c2.user-mode-linux.org>
References: <20090620005524.25582.69677.stgit@menage.mtv.corp.google.com> <4A3F4448.30502@panasas.com> <20090622085735.GB6499@cr0.nay.redhat.com> <20090622205226.fee30ba8.sfr@canb.auug.org.au> <20090625104901.GG6374@cr0.nay.redhat.com> <20090625145155.GA6383@c2.user-mode-linux.org> <20090626120111.ef8622ba.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090626120111.ef8622ba.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 26, 2009 at 12:01:11PM +1000, Stephen Rothwell wrote:
> On out PowerPC host I am using
> 
> 	make ARCH=um SUBARCH=i386 CROSS_COMPILE=<path to i386 cross compiler>
> 
> I am just building defconfig, would another config also be useful?

defconfig is good - that's my normal test config.

> Currently plain "make ARCH=um" on PowerPC doesn't appear to work.

No, it won't.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
