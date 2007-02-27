Return-Path: <linux-kernel-owner+w=401wt.eu-S1751610AbXB0TW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610AbXB0TW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 14:22:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbXB0TW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 14:22:57 -0500
Received: from thunk.org ([69.25.196.29]:56053 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610AbXB0TW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 14:22:56 -0500
Date: Tue, 27 Feb 2007 14:22:53 -0500
From: Theodore Tso <tytso@mit.edu>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070227192253.GB30080@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Al Boldi <a1426z@gawab.com>,
	linux-kernel@vger.kernel.org
References: <200702271715.31184.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702271715.31184.a1426z@gawab.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 27, 2007 at 05:15:31PM +0300, Al Boldi wrote:
> > You may disagree (were you a MacOS 9 programmer
> > in another life?), and it may not even be true for you if you happen
> > to be one of those folks more at home with Scheme continuations, for
> > example.
> 
> Personal attacks are really rather unhelpful/unscientific.

Just to be clear; this wasn't a personal attack.  I know a lot of
people who I greatly respect who were MacOS and Scheme programmers (I
went to school at MIT, after all, the birthplace of Scheme).  The
reality though is that most people don't program that way, and their
brains aren't wired in that fashion.  There is a reason why procedural
languages are far more common than purely functional models, and why
aside from (pre-version 10) MacOS, most OS's don't use an event driven
system call interface.

> So, instead of using intimidating language to force one's opinion thru, 
> especially when it comes from those in control, why not have a democratic 
> vote?

So far, I'd have to say the people arguing for an event driven model
are in the distinct minority...

And as far as voting is concerned, I prefer informed voters who can
explain why, in their own words, why they are in favor of a particular
alternative.

Regards,

						- Ted
