Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbXIASSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbXIASSQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 14:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbXIASSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 14:18:05 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:46242 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533AbXIASSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 14:18:04 -0400
X-Originating-Ip: 72.143.66.27
Date: Sat, 1 Sep 2007 14:06:22 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Dave Jones <davej@redhat.com>
cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: maturity and status and attributes, oh my!
In-Reply-To: <Pine.LNX.4.64.0709011352390.20094@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0709011402570.20725@localhost.localdomain>
References: <Pine.LNX.4.64.0708311720140.29153@localhost.localdomain>
 <46D89800.8080701@s5r6.in-berlin.de> <Pine.LNX.4.64.0709010435070.26137@localhost.localdomain>
 <46D9306C.9040301@s5r6.in-berlin.de> <Pine.LNX.4.64.0709010533260.29190@localhost.localdomain>
 <20070901172231.GA28391@redhat.com> <Pine.LNX.4.64.0709011352390.20094@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Sep 2007, Robert P. J. Day wrote:

> On Sat, 1 Sep 2007, Dave Jones wrote:

> > People just don't care about how mature an option is if they need
> > a driver/feature.  *No-one* is going to come across options and
> > think "Oh, the driver for my network card isn't stable. Guess I'll
> > not enable it". And the idea of hiding the options behind multiple
> > levels of maturity options sounds completely batshit.

by the way and just for the record, dave, you have the above
completely backwards.  the default for what you would be allowed to
select or deselect would be *everything*.  what this whole maturity
level thing would allow you to do is selectively *deselect* (or
*filter*) what is displayed.  in short, if you do nothing, you see no
effect.

so i don't mind folks criticizing the proposal.  but it sure would be
nice if they understood what they were criticising, know what i mean?

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
