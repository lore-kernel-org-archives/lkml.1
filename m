Return-Path: <linux-kernel-owner+w=401wt.eu-S1755149Ab0AEWCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149Ab0AEWCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 17:02:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754754Ab0AEWCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 17:02:19 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:41301 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545Ab0AEWCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 17:02:18 -0500
Date: Wed, 6 Jan 2010 09:02:16 +1100
From: Simon Horman <horms@verge.net.au>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
       Kexec Mailing List <kexec@lists.infradead.org>,
       Venkappa Mala <Venkappa.Mala@lntinfotech.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: Linux kernel crash dumps for ARM
Message-ID: <20100105220216.GA8630@verge.net.au>
References: <EB1A7C66AD0C92419BFFC785A947865A09EA8C9129@BLRINMSMBX01.bglrodc.lntinfotech.com>
 <m17hrx9lgo.fsf@fess.ebiederm.org>
 <20100105084850.GA27860@linux-sh.org>
 <20100105091625.GA19871@verge.net.au>
 <20100105190047.GD30868@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100105190047.GD30868@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 05, 2010 at 07:00:47PM +0000, Russell King wrote:
> On Tue, Jan 05, 2010 at 08:16:28PM +1100, Simon Horman wrote:
> > To add to this, my understanding is that kexec support varies across
> > different ARM platforms - that is to say, it works on some and fails on
> > others. While this seems to be slowly improving, I'm also aware of any list
> > of what is supported and what isn't.
> 
> I'm unaware of that; the only area of weakness with kexec that I'm
> aware of is when the ARMv7 processor support didn't implement the
> necessary code to bring the caches/mmu/tlbs into a safe state for
> software-reboot, which is also what's required by kexec.

Ok, I could well be mistaken and its just ARMv7 that has a few issues
at this time.

