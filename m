Return-Path: <linux-kernel-owner+w=401wt.eu-S1754043AbYJXCIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbYJXCIe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 22:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764AbYJXCIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 22:08:24 -0400
Received: from ozlabs.org ([203.10.76.45]:50605 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbYJXCIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 22:08:23 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: linux-next: drivers/lguest/page_tables.c:1044: error: invalid initializer
Date: Fri, 24 Oct 2008 13:08:23 +1100
User-Agent: KMail/1.9.10
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Matias Zabaljauregui <zabaljauregui@gmail.com>
References: <20081023213637.eff9b414.sfr@canb.auug.org.au> <20081023144814.GA3754@x200.localdomain>
In-Reply-To: <20081023144814.GA3754@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810241308.23959.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 October 2008 01:48:14 Alexey Dobriyan wrote:
> On i386-smp-y-debug-y-preempt-n-paravirt-y-mem-01:
>
> drivers/lguest/page_tables.c: In function 'setup_pagetables':
> drivers/lguest/page_tables.c:1044: error: invalid initializer

This is the lguest PAE patches, which I've pushed back for the moment (even 
after this fix, it crashed my host and I haven't had time to figure out why).

Thanks,
Rusty.


