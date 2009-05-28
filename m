Return-Path: <linux-kernel-owner+w=401wt.eu-S1754658AbZE1G3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbZE1G3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 02:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751083AbZE1G3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 02:29:36 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59770 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750951AbZE1G3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 02:29:35 -0400
Date: Thu, 28 May 2009 07:28:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Roland Dreier <rdreier@cisco.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, Greg KH <gregkh@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Chris Wright <chrisw@redhat.com>,
       kurt.hackel@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
       Ky Srinivasan <ksrinivasan@novell.com>, Beulich <jbeulich@novell.com>,
       Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 17/17] xen: disable MSI
Message-ID: <20090528072844.4c1db656@lxorguk.ukuu.org.uk>
In-Reply-To: <adavdnm5hkx.fsf@cisco.com>
References: <1243409850-21577-1-git-send-email-jeremy@goop.org>
	<1243409850-21577-18-git-send-email-jeremy@goop.org>
	<alpine.LFD.2.01.0905270829530.3435@localhost.localdomain>
	<20090527211828.GA6166@elte.hu>
	<alpine.LFD.2.01.0905271436140.3435@localhost.localdomain>
	<adavdnm5hkx.fsf@cisco.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I could see adding a tag along the lines of tested-by, reported-by,
> reviewed-by, etc.  Maybe something like
> 
>     Closes-bug: <URL>

That would be useful and speed up closing bugs from changelogs. Right now
thats a grep and human task.
