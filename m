Return-Path: <linux-kernel-owner+w=401wt.eu-S1759543AbYCGIHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759543AbYCGIHh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 03:07:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756862AbYCGIHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 03:07:21 -0500
Received: from www.tglx.de ([62.245.132.106]:50390 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756746AbYCGIHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 03:07:20 -0500
Date: Fri, 7 Mar 2008 09:06:59 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Valdis.Kletnieks@vt.edu
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc3-mm1 - BUG at system shutdown time
In-Reply-To: <4954.1204876349@turing-police.cc.vt.edu>
Message-ID: <alpine.LFD.1.00.0803070857360.3099@apollo.tec.linutronix.de>
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org> <10815.1204862325@turing-police.cc.vt.edu>            <20080306221602.790cd26e.akpm@linux-foundation.org> <4954.1204876349@turing-police.cc.vt.edu>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Mar 2008, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 06 Mar 2008 22:16:02 PST, Andrew Morton said:
> > > [   74.254402] CPU 1 is now offline
> > > [   74.255395] SMP alternatives: switching to UP code
> > > [   74.256373] BUG: unable to handle kernel paging request at ffffffff8020a023

Can you decode ffffffff8020a023 via addr2line please ?

Thanks,
	tglx
