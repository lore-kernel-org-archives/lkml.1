Return-Path: <linux-kernel-owner+w=401wt.eu-S1755086AbYIEAIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086AbYIEAIH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 20:08:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbYIEAH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 20:07:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49928 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbYIEAHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 20:07:55 -0400
Subject: Re: linux-next: Tree for September 4
From: David Woodhouse <dwmw2@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080904165309.b5fd9214.akpm@linux-foundation.org>
References: <20080904193606.573f2cb3.sfr@canb.auug.org.au>
	 <20080904165309.b5fd9214.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 05 Sep 2008 01:07:49 +0100
Message-Id: <1220573269.4843.1.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-09-04 at 16:53 -0700, Andrew Morton wrote:
> 
> sparc64 `make headers_check':
> 
> make[1]: *** No rule to make target
> `/usr/src/devel/arch/sparc/include/asm/statfs_32.h', needed by
> `/usr/src/devel/usr/include/asm/.install'.  Stop.

Fixed in ~dwmw2/random-2.6.git. Thanks.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

