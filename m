Return-Path: <linux-kernel-owner+w=401wt.eu-S1757423AbXHRQla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423AbXHRQla (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 12:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750967AbXHRQlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 12:41:12 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:2449 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756749AbXHRQk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 12:40:57 -0400
Date: Sat, 18 Aug 2007 18:45:05 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Joe Perches <joe@perches.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] [540/2many] MAINTAINERS - WATCHDOG DEVICE DRIVERS
Message-ID: <20070818164505.GA3201@infomag.infomag.iguana.be>
References: <46bffcab.hvODrZFyIOzH/Lb/%joe@perches.com> <20070816194638.GA3498@infomag.infomag.iguana.be> <20070816203034.GA4495@infomag.infomag.iguana.be> <1187297077.5906.107.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1187297077.5906.107.camel@localhost>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

> > Patch removed until there is a consensus on how to proceed with your proposal.
> 
> Hi Wim.
> 
> I think that's wise.
> 
> I've got all the changes that people have CC'd me.
> I expect it'll be an all or nothing sort of thing.

My opinion: the patch you sent me was just adding the differen watchdog
related files/directories to my maintainers entry. Since someone (in the past)
did not sent in a patch directly to me because he had searched only on WDT and
not watchdog, I thought: why not, it can only improve the searching for
a maintainer.

But what Linus said is indeed true: managing the MAINTAINERS file is difficult.
How many maintainer entry's would we have where we don't know that the person
stopped developing (and thus maintaining), or that the person died, or that he
is unreachable for any outside communication (because he is in prison or because
he choose to retire on a beautifull island with only palm-trees and quiteness),
...
Example: We recently removed the maintainer entry for Ken Hollis (who definitely
was involved in the first watchdog device drivers) because he was not "reachable"
anymore via E-mail. Who knows what happened...

So the maintenance of the "maintainers" will always be difficult. Adding a new
entry is part of the development process, but removing one not. And this is
regardless of whatever "system" you use to store the maintainers.

So even if your patches will not be accepted in it's current form, I think it
is/was good that you had a look at all the maintainers file and tried to find
out how accurate the info was.

Greetings,
Wim.
