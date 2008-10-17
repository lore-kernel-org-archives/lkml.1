Return-Path: <linux-kernel-owner+w=401wt.eu-S1756756AbYJQTI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756AbYJQTI3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 15:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbYJQTIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 15:08:20 -0400
Received: from gv-out-0910.google.com ([216.239.58.186]:18204 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547AbYJQTIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 15:08:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=oL5yIcf61hKBkcDt2yo1bbv0ugix9cpGKPOplLrCk2BN14zWqM00jm2MpDYQWC8wnd
         gCMCgEY+Ei4m7dKFH6ztc5G/P7q2+ak8MewZqM8xf/HXP6U4cveEnonJDOxMRsTHufeb
         kZ4Y6eFOjUW81sT6/duMDv/elisGa06t77TL4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Greg KH <greg@kroah.com>
Subject: Re: [RFC] Kernel version numbering scheme change
Date: Fri, 17 Oct 2008 21:06:28 +0200
User-Agent: KMail/1.9.10
Cc: Steven Noonan <steven@uplinklabs.net>, Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <20081016002509.GA25868@kroah.com> <f488382f0810170116qd7e1845h8942c195352934d1@mail.gmail.com> <20081017174657.GH2221@kroah.com>
In-Reply-To: <20081017174657.GH2221@kroah.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200810172106.29154.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 October 2008, Greg KH wrote:
> On Fri, Oct 17, 2008 at 01:16:38AM -0700, Steven Noonan wrote:
> > I believe some of Adrian's concerns are valid. Userspace programs will
> > indeed break, largely because some depend on build-time and run-time
> > checks for the kernel version being >=2.6.0 or >=2.4.0 and so forth. I
> > suspect the best way to prove userspace breakage would be to make a
> > branch of the kernel with a new versioning scheme (8.10, 2008.10,
> > whatever) and use that as the installed kernel while building a Gentoo
> > system. I suspect you'd see massive breakage.
> 
> That would be trivial for me to test, IFF we want to do something like
> this.
> 
> But again, that's a technical thing, that can be solved _IFF_ we want to
> change things.
> 
> And that's my point here, do we want to change the current numbering
> scheme as people have expressed annoyances of the current one.

Numbering scheme?  I thought we should all be using the official
kernel version NAME after the -final release?  Was I mistaken?

PS1 seems like somebody forgot to update it for 2.6.27...

PS2 current numbering scheme is OK

Thanks,
Bart
