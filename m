Return-Path: <linux-kernel-owner+w=401wt.eu-S1756842AbZCLVVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842AbZCLVVm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 17:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754410AbZCLVVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 17:21:32 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:51315 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbZCLVVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 17:21:31 -0400
Date: Thu, 12 Mar 2009 16:21:24 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Greg Kurz <gkurz@fr.ibm.com>
Cc: Cedric Le Goater <legoater@free.fr>,
       Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org,
       containers@lists.linux-foundation.org, mpm@selenic.com,
       linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>,
       linux-mm@kvack.org, tglx@linutronix.de, viro@zeniv.linux.org.uk,
       hpa@zytor.com, mingo@elte.hu, torvalds@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>, xemul@openvz.org
Subject: Re: How much of a mess does OpenVZ make? ;) Was: What can OpenVZ
	do?
Message-ID: <20090312212124.GA25019@us.ibm.com>
References: <1234467035.3243.538.camel@calx> <20090212114207.e1c2de82.akpm@linux-foundation.org> <1234475483.30155.194.camel@nimitz> <20090212141014.2cd3d54d.akpm@linux-foundation.org> <1234479845.30155.220.camel@nimitz> <20090226155755.GA1456@x200.localdomain> <20090310215305.GA2078@x200.localdomain> <49B775B4.1040800@free.fr> <20090312145311.GC12390@us.ibm.com> <1236891719.32630.14.camel@bahia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236891719.32630.14.camel@bahia>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Greg Kurz (gkurz@fr.ibm.com):
> On Thu, 2009-03-12 at 09:53 -0500, Serge E. Hallyn wrote:
> > Or are you suggesting that you'll do a dummy clone of (5594,2) so that
> > the next clone(CLONE_NEWPID) will be expected to be (5594,3,1)?
> > 
> 
> Of course not

Ok - someone *did* argue that at some point I think...

> but one should be able to tell clone() to pick a specific
> pid.

Can you explain exactly how?  I must be missing something clever.

-serge
