Return-Path: <linux-kernel-owner+w=401wt.eu-S1161143AbXCNLZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161143AbXCNLZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 07:25:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161149AbXCNLZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 07:25:35 -0400
Received: from xenotime.net ([66.160.160.81]:51704 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1161143AbXCNLZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 07:25:34 -0400
Date: Wed, 14 Mar 2007 04:25:22 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: Andrew Morton <akpm@linux-foundation.org>
cc: Nilshar@gmail.com,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [Bug 8040] Hang before INIT when CONFIG_HIGHMEM4G=y
In-Reply-To: <20070314041710.770708c4.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.58.0703140422260.28950@shark.he.net>
References: <200703141013.l2EADP6c027144@fire-2.osdl.org>
 <20070314041710.770708c4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Mar 2007, Andrew Morton wrote:

> > On Wed, 14 Mar 2007 03:13:25 -0700 bugme-daemon@bugzilla.kernel.org wrote:
> >
> > http://bugzilla.kernel.org/show_bug.cgi?id=8040
> >
> >
> > ------- Additional Comments From Nilshar@gmail.com  2007-03-14 03:13 -------
> > Any news on that bug please ?
>
> None whatsoever.  Three people are reporting this and it's a drop-dead
> showstopper for a 2.6.21 release so we just have to wait until someone
> wakes up and thinks about it.
>
> It would be very useful if one of the reporters could perform a git-bisect
> search to identify the offending change, please.
>
> I would dearly like to point you at a document or web page which describes
> kernel-git-bisect-for-newbies, but afaik there isn't such a thing, which is
> a huge failing.

I have one of those one-of-my-machines-wont-boot-2.6.21-rc*
and I expect that I'll try to use git bisect on it, in which case
I will also document it.

-- 
~Randy
