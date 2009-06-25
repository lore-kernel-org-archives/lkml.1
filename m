Return-Path: <linux-kernel-owner+w=401wt.eu-S1757978AbZFYP6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978AbZFYP6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 11:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbZFYP6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 11:58:12 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:46358 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbZFYP6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 11:58:11 -0400
X-Greylist: delayed 3782 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Jun 2009 11:58:10 EDT
Date: Thu, 25 Jun 2009 10:51:55 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Boaz Harrosh <bharrosh@panasas.com>, Paul Menage <menage@google.com>,
       akpm@linux-foundation.org, jdike@addtoit.com,
       linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] [PATCH] UML: Fix some apparent bitrot
Message-ID: <20090625145155.GA6383@c2.user-mode-linux.org>
References: <20090620005524.25582.69677.stgit@menage.mtv.corp.google.com> <4A3F4448.30502@panasas.com> <20090622085735.GB6499@cr0.nay.redhat.com> <20090622205226.fee30ba8.sfr@canb.auug.org.au> <20090625104901.GG6374@cr0.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090625104901.GG6374@cr0.nay.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 06:49:01PM +0800, Amerigo Wang wrote:
> make ARCH=um SUBARCH=ppc? Or something similar...

It would need to be
	make ARCH=um 
with an x86 cross-compiler.

				Jeff
