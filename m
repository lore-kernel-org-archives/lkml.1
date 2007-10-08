Return-Path: <linux-kernel-owner+w=401wt.eu-S1755863AbXJHUBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbXJHUBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 16:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755526AbXJHUBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 16:01:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59131 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755498AbXJHUBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 16:01:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Scott Preece" <sepreece@gmail.com>
Subject: Re: RFC: reviewer's statement of oversight
Date: Mon, 8 Oct 2007 22:16:26 +0200
User-Agent: KMail/1.9.5
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Sam Ravnborg" <sam@ravnborg.org>, "Jonathan Corbet" <corbet@lwn.net>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>
References: <25555.1191864285@lwn.net> <20071008185225.GK2902@fieldses.org> <7b69d1470710081226w5b6682e6q56bfa2af5ae3f017@mail.gmail.com>
In-Reply-To: <7b69d1470710081226w5b6682e6q56bfa2af5ae3f017@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710082216.28227.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 8 October 2007 21:26, Scott Preece wrote:
> On 10/8/07, J. Bruce Fields <bfields@fieldses.org> wrote:
> > On Mon, Oct 08, 2007 at 08:34:47PM +0200, Stefan Richter wrote:
> ...
> > > So, putting a Tested-by into the changelog is only useful if the
> > > necessary testing is rather simple (i.e. "fixed the bug which I was
> > > always able to reproduce before") or if the tester is known to have
> > > performed rigorous and sufficiently broad tests.
> >
> > Well, you can still include those test-method details in the body of the
> > message in addition to adding the "Tested-by:".
> >
> > Does "Tested-by" just mean they ran some relevant test on the final
> > version of the patch?  The really hard part is often the initial work
> > required to find a good reproduceable test case, capture the right error
> > report, or bisect to the right commit.  I think that also counts as
> > "testing".  And it'd be nice to have a tag for those sorts of
> > contributions, partly just as another way to ackowledge them.
> ---
> 
> Tested-by should, at the very least, have a description of the test
> environment in the body (suggesting that the change compiled and ran
> in that environment). Preferably it should also have a description of
> the test or test suite run and whether that test failed on an
> unpatched system.

Tested-by: is sort of trivial for a fix patch, for example, if a bug reporter
confirms that the proposed patch actually fixes the issue.  IMHO it wouldn't
be practical to complicate that.

Greetings,
Rafael
