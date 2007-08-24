Return-Path: <linux-kernel-owner+w=401wt.eu-S1764638AbXHXNI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764638AbXHXNI3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 09:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757396AbXHXNIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 09:08:20 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:58315 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756850AbXHXNIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 09:08:20 -0400
Date: Fri, 24 Aug 2007 07:08:17 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Jes Sorensen <jes@sgi.com>
Cc: Adrian Bunk <bunk@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Tech Board Discuss 
	<Tech-board-discuss@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andy Isaacson <adi@hexapodia.org>, Josh Boyer <jwboyer@gmail.com>,
       ksummit-2007-discuss@thunk.org
Subject: Re: [Tech-board-discuss] Re: [Ksummit-2007-discuss] Re: Linux	Foundation Technical Advisory Board Elections
Message-ID: <20070824130817.GW9163@parisc-linux.org>
References: <20070823004209.GP9163@parisc-linux.org> <20070823011953.GS30556@waste.org> <1187832907.3410.141.camel@localhost.localdomain> <20070824012730.GA1243@hexapodia.org> <625fc13d0708231934q5b369b4fh1a5c83def0e56a0d@mail.gmail.com> <20070824025254.GH21720@waste.org> <20070824025504.GT9163@parisc-linux.org> <20070824045413.GX30705@stusta.de> <20070824115601.GU9163@parisc-linux.org> <46CECB60.6010901@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46CECB60.6010901@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2007 at 02:13:20PM +0200, Jes Sorensen wrote:
> Personally I am not sure whether SPI would be the right way to do it or
> not, I am a bit wary of it being too Debian biased, but I could be
> convinced otherwise.

I don't think it's the /perfect/ organisation by any means, but let's
consider the requirements:

 - Membership open to significant contributors to 'Linux' [1]
 - Has a voting process
 - Reasonably agnostic

Maybe an organisation like Linux International could handle this too,
but I don't know whether they have a membership process.

> Given that the git commit rate has already been used for a number of
> appointments, and partially to select the cabal which currently have the
> option to vote for the TAB. It seems pretty to set a threshold such that
> anyone with more than X commits (random number out of a hat, say 5) will
> get a vote - one vote per person. This avoids the issue of people who
> send out 317 patches of one-liners for comments to the MAINTAINERS file
> will gain an unproportional number of votes. I don't have the impression
> that there is a hierachy within the KS attendees providing them a number
> of votes based on their number of contributions either?

I ran the election last year (by counting hands) and there was no
weighting by contribution ;-)  More important though is the expressed
desire for the TAB to be more than kernel people.

[1] Is Linux even the right term?  The work done by the former FSG is
relevant to BSDs and Solaris.  Not to mention the kernel vs distro
discussion.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
