Return-Path: <linux-kernel-owner+w=401wt.eu-S1030996AbXDRCPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030996AbXDRCPj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 22:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031304AbXDRCPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 22:15:39 -0400
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:53526 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030996AbXDRCPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 22:15:38 -0400
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: AppArmor FAQ
Date: Wed, 18 Apr 2007 02:08:56 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <f03ujo$cta$1@taverner.cs.berkeley.edu>
References: <20070416213350.GB4030@suse.de> <1176852059.5946.128.camel@localhost.localdomain> <f03mli$8g8$1@taverner.cs.berkeley.edu> <Line.LNX.4.64.0704172143150.21359@d.namei>
Reply-To: daw-usenet@taverner.cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1176862136 13226 128.32.168.222 (18 Apr 2007 02:08:56 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Wed, 18 Apr 2007 02:08:56 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris  wrote:
>On Tue, 17 Apr 2007, David Wagner wrote:
>> Maybe you'd like to confine the PHP interpreter to limit what it can do.
>> That might be a good application for something like AppArmor.  You don't
>> need comprehensive information flow control for that kind of use, and
>> it would likely just get in the way.
>
>SELinux can do this, it's policy-flexible.  You can even simulate a 
>pathame-based policy language with a consequential loss of control:

I have no doubt that SELinux can do that, but that has about as much
relevance to my point as the price of tea in China does.  I can use a
screwdriver to drive in a nail into my wall, too, if I really wanted to,
but that doesn't mean toolmakers should stop manufacturing hammers.

My point is that there are some tasks where it's plausible that AppArmor
might well be a better (easier-to-use) tool for the job.  I'm inclined
to suspect I might find it easier to use AppArmor for this kind of task
than SELinux, and I suspect I'm not the only one.  That doesn't mean
that AppArmor is somehow inherently superior to SELinux, or something
like that.

No one is claiming that AppArmor is "a better SELinux".  It solves
a somewhat different problem, and has a different set of tradeoffs.
It seems potentially useful.  That ought to be enough.  The world does
not revolve around SELinux.
