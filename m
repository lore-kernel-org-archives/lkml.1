Return-Path: <linux-kernel-owner+w=401wt.eu-S1756088AbYCJWI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbYCJWI6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 18:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752448AbYCJWIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 18:08:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58113 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbYCJWIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 18:08:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frank Sorenson <frank@tuxrocks.com>
Subject: Re: 2.6.25-rc4-git3: Reported regressions from 2.6.24
Date: Mon, 10 Mar 2008 23:08:05 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
References: <200803100132.57160.rjw@sisk.pl> <47D4BA48.4080107@tuxrocks.com>
In-Reply-To: <47D4BA48.4080107@tuxrocks.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803102308.06503.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 10 of March 2008, Frank Sorenson wrote:
> Rafael J. Wysocki wrote:
> > [Due to the lack of time for reviewing all of the email threads related to the
> > regressions marked as "unresolved" below, I might have missed some patches
> > fixing them.  If you are involved in debugging/fixing any of them, please let
> > me know if I should update the list.  Thanks!]
> >
> > This message contains a list of some regressions from 2.6.24 reported since
> > 2.6.25-rc1 was released, for which there are no fixes in the mainline I know
> > of.  If any of them have been fixed already, please let me know.
> >
> > If you know of any other unresolved regressions from 2.6.24, please let me know
> > either and I'll add them to the list.  Also, please let me know if any of the
> > entries below are invalid.
> 
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10187
> > Subject		: 2.6.25-rc4 OOMs itself dead on bootup
> > Submitter	: Frank Sorenson <frank@tuxrocks.com>
> > Date		: 2008-03-06 17:26
> > References	: http://marc.info/?l=linux-kernel&amp;m=120482709209046&amp;w=2
> > Handled-By	: Ingo Molnar <mingo@elte.hu>
> > Patch		: http://lkml.org/lkml/2008/3/8/15
> 
> Not a regression, and the patch is not required.  The OOM was caused by
> something specific to my system, and it's been resolved.

Thanks, updated.

Rafael
