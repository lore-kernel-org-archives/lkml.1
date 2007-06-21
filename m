Return-Path: <linux-kernel-owner+w=401wt.eu-S1757834AbXFUSB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757834AbXFUSB3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 14:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759041AbXFUSAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 14:00:31 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40035 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758525AbXFUSAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 14:00:30 -0400
Date: Thu, 21 Jun 2007 19:00:29 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Alexandre Oliva <aoliva@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: how about mutual compatibility between Linux's GPLv2 and GPLv3?
Message-ID: <20070621180029.GR21478@ftp.linux.org.uk>
References: <orlkedpryc.fsf@oliva.athome.lsd.ic.unicamp.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <orlkedpryc.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2007 at 06:39:07AM -0300, Alexandre Oliva wrote:
> Here's an idea that just occurred to me, after all the discussions
> about motivations, tit-for-tat, authors' wishes and all.
> 
> If GPLv3 were to have a clause that permitted combination/linking with
> code under GPLv2, this wouldn't be enough for GPLv3 projects to use
> Linux code, and it wouldn't be enough for Linux code to use GPLv3
> projects.  That's because GPLv2 would still demand all code to be
> licensed under GPLv2, and GPLv3 wouldn't permit this.
> 
> However, if GPLv3 had a permission to combine/link with code under
> GPLv2, *and* Linux (and any other projects interested in mutual
> compatibility) introduced an additional permission to combine/link
> with code under GPLv3 (or even GPLv3+, constrained by some condition
> if you will), then:
>
> - the kernel Linux could use code from GPLv3 projects

... and inherit GPLv3 additional restrictions.  No.

> - GPLv3 projects could use code from Linux

Oh, rapture!  How could one object against such a glorious outcome?

> - each copyright holder would still get to enforce the terms s/he
>   chose for his/her own code

... except for that pesky "no added restrictions" part, but hey, who
cares?

> If you were to permit compatibility with GPLv3+ (rather than GPLv3),
> would you constrain it?  Would something like:
> 
>   as long as the later version grants each licensee the same
>   permissions as GPLv2, except for constraining permissions that would
>   enable one licensee to deny other licensees the exercise of the
>   permissions granted by both licenses

... because it's For The Benefit Of User Freedoms!!!

No.  Permission denied.  And I don't know of any suckers who would buy that
and hadn't been already hooked by FSF peddlers already.

If somebody wants to dual-license their code, they can do it just fine.
If somebody wants to dual-license *others* code, they can go and play
with themselves until they reach RMS-level clarity of vision.

