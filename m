Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab0CIM7R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 07:59:17 -0500
Received: from verein.lst.de ([213.95.11.210]:54825 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239Ab0CIM7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 07:59:14 -0500
Date: Tue, 9 Mar 2010 13:58:17 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>,
       "H. Peter Anvin" <hpa@zytor.com>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       tony.luck@intel.com, ralf@linux-mips.org, kyle@mcmartin.ca,
       benh@kernel.crashing.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, tglx@linutronix.de, mingo@redhat.com,
       viro@zeniv.linux.org.uk
Subject: Re: [PATCH 4/6] improve sys_personality for compat architectures
Message-ID: <20100309125817.GA18435@lst.de>
References: <201002021536.51928.arnd@arndb.de> <20100203.091309.52886984.davem@davemloft.net> <4B69D6BA.4030704@zytor.com> <201002040838.10783.arnd@arndb.de> <20100204160057.GA5120@lst.de> <20100305114911.ef629eb1.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100305114911.ef629eb1.akpm@linux-foundation.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 05, 2010 at 11:49:11AM -0800, Andrew Morton wrote:
> > Yes, this should be common over architectures.  Anyway, I expect there
> > to be some discussion until we've reached that point, so for now I'll
> > rebase patches 5 and 6 to not require this patch, and will send one
> > to kill the unused x86 implementation.  Whatever is the final outcome
> > can be implemented on top.
> > 
> 
> This never happened?

Seems like no one cared enough to discuss this issue in detail.  I'll
start a fresh discussion once we got the other patches in and I have
a clean sheet to work against.
