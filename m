Return-Path: <linux-kernel-owner+w=401wt.eu-S1754785AbXJIG1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbXJIG1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 02:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbXJIG12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 02:27:28 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:51718 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbXJIG11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 02:27:27 -0400
Date: Tue, 9 Oct 2007 08:27:57 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Scott Preece <sepreece@gmail.com>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Jonathan Corbet <corbet@lwn.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: RFC: reviewer's statement of oversight
Message-ID: <20071009062757.GA22303@uranus.ravnborg.org>
References: <25555.1191864285@lwn.net> <20071008185225.GK2902@fieldses.org> <7b69d1470710081226w5b6682e6q56bfa2af5ae3f017@mail.gmail.com> <200710082216.28227.rjw@sisk.pl> <20071009020750.GB4504@goodmis.org> <470B1BA9.7080509@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <470B1BA9.7080509@s5r6.in-berlin.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2007 at 08:11:53AM +0200, Stefan Richter wrote:
> Steven Rostedt wrote:
> > But for those that run test suites, they should be smart enough to put
> > in more documentation into the change log to state how it was tested.
> 
> I disagree.  The SCM changelog should contain _what_ a patch does and if
> necessary _why_ it does so.
The _why_ part is more important than _what_. The diff should hopefully
explain the _what_ part.

	Sam
