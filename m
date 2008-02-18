Return-Path: <linux-kernel-owner+w=401wt.eu-S1758736AbYBRL0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736AbYBRL0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 06:26:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757125AbYBRL0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 06:26:45 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42413 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755680AbYBRL0o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 06:26:44 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: 2.6.25-rc2: Reported regressions from 2.6.24
Date: Mon, 18 Feb 2008 12:24:53 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Ingo Molnar <mingo@elte.hu>
References: <200802172304.00322.rjw@sisk.pl> <20080217213733.0c46a98f@laptopd505.fenrus.org>
In-Reply-To: <20080217213733.0c46a98f@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802181224.54731.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 18 of February 2008, Arjan van de Ven wrote:
> On Sun, 17 Feb 2008 23:03:59 +0100
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > [This is a bit late, for which I'm sorry, but I waited for things to
> > calm down a bit, to have something less of a moving target.
> > 
> > Now, following an Ingo's advice, the list has been generated directly
> > out of the Bugzilla entries used for tracking the bugs.  I'm going to
> > release the script used for generating the list, so that it can be
> > recreated by anyone on the fly.]
> > 
> > This message contains a list of some regressions from 2.6.24 reported
> > since 2.6.25-rc1 was released, for which there are no fixes in the
> > mainline I know of.  If any of them have been fixed already, please
> > let me know.
> > 
> > If you know of any other unresolved regressions from 2.6.24, please
> > let me know either and I'll add them to the list.  Also, please let
> > me know if any of the entries below are invalid.
> 
> 
> question: can we please list the last known good version for each entry?
> Since these are all regressions (right?) that information ought to be available 
> and usually helps down in narrowing causes..

Well, this usually is only obvious for the cases in which the "guilty" commit
has been identified and that information is already provided in the Bugzilla
entries.

I can add a "Caused-By" tag so that it gets listed, if that helps.

Thanks,
Rafael
