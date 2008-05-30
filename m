Return-Path: <linux-kernel-owner+w=401wt.eu-S1756541AbYE3W51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541AbYE3W51 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 18:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059AbYE3W5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 18:57:18 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:35980 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753211AbYE3W5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 18:57:17 -0400
Date: Fri, 30 May 2008 18:53:20 -0400
From: Theodore Tso <tytso@mit.edu>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Hugh Dickins <hugh@veritas.com>, Greg KH <greg@kroah.com>,
       Dave Jones <davej@redhat.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       David Woodhouse <dwmw2@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2008-discuss] How many contributors are we losing
Message-ID: <20080530225320.GA3380@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Luck, Tony" <tony.luck@intel.com>, Hugh Dickins <hugh@veritas.com>,
	Greg KH <greg@kroah.com>, Dave Jones <davej@redhat.com>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	ksummit-2008-discuss@lists.linux-foundation.org,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	David Woodhouse <dwmw2@infradead.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <20080528225136.GA29014@kroah.com> <1FE6DD409037234FAB833C420AA843EC016FFF69@orsmsx424.amr.corp.intel.com> <20080529003657.GA17505@kroah.com> <20080529010055.GA31952@redhat.com> <20080529022632.GB5180@kroah.com> <1FE6DD409037234FAB833C420AA843EC017405EB@orsmsx424.amr.corp.intel.com> <Pine.LNX.4.64.0805302205160.28487@blonde.site> <1FE6DD409037234FAB833C420AA843EC01740760@orsmsx424.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FE6DD409037234FAB833C420AA843EC01740760@orsmsx424.amr.corp.intel.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2008 at 03:05:12PM -0700, Luck, Tony wrote:
> 
> Probably some of them moved on to do different things (or were
> promoted to manage people who still work on Linux).

There's an interesting unspoken assumption here that people who stop
contributing patches which end up in the Linux kernel mailing "no
longer working on the kernel", or "no longer working in Linux", or
"left the community", or (even more of a stretch) people that we have
somehow driven away or that we have failed because they didnt come
back.

Looking at the list.....

> Werner Almesberger

	Original author of LILO, does networking research using the
	Linux kernel.  (Has shown up and presented papers at various
	conferences such as FISL and Linux.conf.au.)

> Stephen Tweedie

	Still working at Red Hat, my last knowledge was that he was in
	Xen hell.....

> Kylene Jo Hall

	Member of IBM Linux Technology Center, Security Team.
	The security team does a lot more than kernel work....

> Dustin Kirkland

	Was a member of the IBM Linux Technology Center, now working
	for Canonical on Ubuntu's Enterprise Server Team

> Suparna Bhattacharya

	Member of the IBM Linux Technology Center, on leave to get an
	advanced degree.

> Junio C Hamano

	Git maintainer.  :-)

So lots of stories, and there are plenty of people who are still
working at a company doing Linux work; they're just not happening to
contribute to a kernel.  They might be fixing bugs for customers, or
forward porting Xen for an enterprise distro, or many other things
that are intimately related to the Linux kernel --- just not in ways
that result in patches into mainline.

So if we really want some hard numbers on how many kernel developers
we are "losing", we would probably have to try to contact some of
these people and see if they are willing to answer a survey.  But
given your numbers, I really don't think it's as big a problem as some
people make it out to be....

						- Ted
