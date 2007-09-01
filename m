Return-Path: <linux-kernel-owner+w=401wt.eu-S1756893AbXIASY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893AbXIASY7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 14:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754419AbXIASYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 14:24:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753923AbXIASYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 14:24:51 -0400
Date: Sat, 1 Sep 2007 14:24:41 -0400
From: Dave Jones <davej@redhat.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: maturity and status and attributes, oh my!
Message-ID: <20070901182441.GA8571@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Robert P. J. Day" <rpjday@mindspring.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0708311720140.29153@localhost.localdomain> <46D89800.8080701@s5r6.in-berlin.de> <Pine.LNX.4.64.0709010435070.26137@localhost.localdomain> <46D9306C.9040301@s5r6.in-berlin.de> <Pine.LNX.4.64.0709010533260.29190@localhost.localdomain> <20070901172231.GA28391@redhat.com> <Pine.LNX.4.64.0709011352390.20094@localhost.localdomain> <Pine.LNX.4.64.0709011402570.20725@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709011402570.20725@localhost.localdomain>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 01, 2007 at 02:06:22PM -0400, Robert P. J. Day wrote:
 > On Sat, 1 Sep 2007, Robert P. J. Day wrote:
 > 
 > > On Sat, 1 Sep 2007, Dave Jones wrote:
 > 
 > > > People just don't care about how mature an option is if they need
 > > > a driver/feature.  *No-one* is going to come across options and
 > > > think "Oh, the driver for my network card isn't stable. Guess I'll
 > > > not enable it". And the idea of hiding the options behind multiple
 > > > levels of maturity options sounds completely batshit.
 > 
 > by the way and just for the record, dave, you have the above
 > completely backwards.  the default for what you would be allowed to
 > select or deselect would be *everything*.  what this whole maturity
 > level thing would allow you to do is selectively *deselect* (or
 > *filter*) what is displayed.  in short, if you do nothing, you see no
 > effect.

>From your earlier mail..

"all this new construct is doing is implementing a new way to globally
 select or de-select large sets of kernel features to display for user
 selection, in exactly the way that EXPERIMENTAL does it now, that's all."
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

EXPERIMENTAL hides options.

 > so i don't mind folks criticizing the proposal.  but it sure would be
 > nice if they understood what they were criticising, know what i mean?

Quite.

	Dave

-- 
http://www.codemonkey.org.uk
