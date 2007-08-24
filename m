Return-Path: <linux-kernel-owner+w=401wt.eu-S1762069AbXHXMVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762069AbXHXMVp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 08:21:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757396AbXHXMVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 08:21:38 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40503 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755845AbXHXMVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 08:21:37 -0400
Message-ID: <46CECB60.6010901@sgi.com>
Date: Fri, 24 Aug 2007 14:13:20 +0200
From: Jes Sorensen <jes@sgi.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
Cc: Adrian Bunk <bunk@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Tech Board Discuss 
	<Tech-board-discuss@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andy Isaacson <adi@hexapodia.org>, Josh Boyer <jwboyer@gmail.com>,
       ksummit-2007-discuss@thunk.org
Subject: Re: [Tech-board-discuss] Re: [Ksummit-2007-discuss] Re: Linux	Foundation
 Technical Advisory Board Elections
References: <20070823002618.GO9163@parisc-linux.org>	<20070823003748.GR30556@waste.org>	<20070823004209.GP9163@parisc-linux.org>	<20070823011953.GS30556@waste.org>	<1187832907.3410.141.camel@localhost.localdomain>	<20070824012730.GA1243@hexapodia.org>	<625fc13d0708231934q5b369b4fh1a5c83def0e56a0d@mail.gmail.com>	<20070824025254.GH21720@waste.org>	<20070824025504.GT9163@parisc-linux.org>	<20070824045413.GX30705@stusta.de> <20070824115601.GU9163@parisc-linux.org>
In-Reply-To: <20070824115601.GU9163@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Fri, Aug 24, 2007 at 06:54:14AM +0200, Adrian Bunk wrote:
>> My impression as an SPI member is that in practice most SPI members come 
>> from the SPI projects [1], and due to Debian's size Debian developers 
>> are the majority of SPI members.
> 
> That's true -- but bear in mind that most SPI members are inactive, and
> don't even vote for SPI leader.  I doubt most existing members could be
> bothered to vote for Linux Foundation TAB.

Hi,

It was fair enough to run the vote at KS last year to get the TAB
started in the first place. However limiting the vote to a small closed
cabal, for the future, pretty much ensures that anyone will ever stand a
chance to challenge the board if they felt a change of direction was
needed. I don't have the old emails at hand, but I thought it was stated
clearly last year that the intention was to change the process for the
future?

Personally I am not sure whether SPI would be the right way to do it or
not, I am a bit wary of it being too Debian biased, but I could be
convinced otherwise.

Given that the git commit rate has already been used for a number of
appointments, and partially to select the cabal which currently have the
option to vote for the TAB. It seems pretty to set a threshold such that
anyone with more than X commits (random number out of a hat, say 5) will
get a vote - one vote per person. This avoids the issue of people who
send out 317 patches of one-liners for comments to the MAINTAINERS file
will gain an unproportional number of votes. I don't have the impression
that there is a hierachy within the KS attendees providing them a number
of votes based on their number of contributions either?

Regards,
Jes
