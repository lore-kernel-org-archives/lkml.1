Return-Path: <linux-kernel-owner+w=401wt.eu-S1752049AbXEXQzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbXEXQzY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 12:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750786AbXEXQzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 12:55:09 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:40688 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750776AbXEXQzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 12:55:07 -0400
Date: Thu, 24 May 2007 09:54:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, viro@zeniv.linux.org.uk,
       Uwe Bugla <uwe.bugla@gmx.de>, Ken Chen <kenchen@google.com>,
       xfs-masters@oss.sgi.com, Jeremy Fitzhardinge <jeremy@goop.org>,
       David Chinner <dgc@sgi.com>,
       Andrea Righi <righiandr@users.sourceforge.net>,
       Christoph Lameter <clameter@sgi.com>, linux-ide@vger.kernel.org,
       Paul Mundt <lethal@linux-sh.org>, Tejun Heo <htejun@gmail.com>,
       Jeff Garzik <jeff@garzik.org>,
       Francis Russell <francisrussell@btopenworld.com>,
       Alan Cox <alan@redhat.com>, Andi Kleen <ak@suse.de>, discuss@x86-64.org,
       Ben Collins <ben.collins@ubuntu.com>
Subject: Re: 2.6.22-rc2: known regressions with patches
Message-Id: <20070524095416.d3371632.akpm@linux-foundation.org>
In-Reply-To: <20070524161116.047c55e9@the-village.bc.nu>
References: <46559B62.5040903@googlemail.com>
	<20070524161116.047c55e9@the-village.bc.nu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007 16:11:16 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > Subject    : pata_via appears to incorrectly detects 40-pin cable
> > References : http://lkml.org/lkml/2007/5/17/273
> >              http://bugzilla.kernel.org/show_bug.cgi?id=8142
> > Submitter  : Francis Russell <francisrussell@btopenworld.com>
> > Status     : Not really a regression. Alan seems to have a general fix.
> >              (Tejun Heo)
> 
> The laptop one has been resolved, tested and fired at Andrew.

Do you recall the Subject: on that patch?

> Note btw that the bugzilla and email refer to two differing bugs. The
> SATA one (bugzilla ref) has gone to Jeff and is a different fix.

And that?

Thanks.
