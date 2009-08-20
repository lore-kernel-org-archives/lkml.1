Return-Path: <linux-kernel-owner+w=401wt.eu-S1751897AbZHTPYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897AbZHTPYB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 11:24:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751206AbZHTPYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 11:24:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38417 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbZHTPX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 11:23:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <ncunningham@crca.org.au>
Subject: Re: What to do?
Date: Thu, 20 Aug 2009 17:24:34 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: "linux-pm" <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "TuxOnIce-devel" <tuxonice-devel@lists.tuxonice.net>
References: <4A8CCF95.9030401@crca.org.au>
In-Reply-To: <4A8CCF95.9030401@crca.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908201724.34430.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 August 2009, Nigel Cunningham wrote:
> Hi all.

Hi,

> A few months back, I posted TuxOnIce for something like the third time,
> seeking to see if we could make some progress on getting it merged. The
> outcome of that was an agreement between Rafael and I that we'd work on
> getting TuxOnIce functionality (if not the actual code) merged bit by
> bit, improving swsusp rather than doing an outright merge.
> 
> Unfortunately, as the intervening months have shown, Rafael is busy with
> other things and so am I. The few patches I did prepare and post have
> had no review, and I haven't had a chance to build on or rework them
> since. (I'd actually like them not to be merged, because I've realised
> that there are more foundational changes that need to go in first.)
> 
> Given that this has been the outcome so far, I see no reason to imagine
> that we're going to make any serious progress any time soon.

That unfortunately is probably right.

The problem for my part is that new things are still appearing that I need to
take care of rather urgently.

In fact the user space part of (u)swsusp also has been suffering from the lack
of attention recently, so to speak.

> I'd therefore like to ask whether there's anyone out there who could do
> one or more of:
> 
> 1) Step up to the plate and help improve swsusp, without relying on any
> help from me but with my blessing if they choose to copy wholesale bits
> of TuxOnIce;
> 2) Take over maintaining TuxOnIce from me;
> 3) Some other way forward that hasn't occurred to me.
> 
> Thoughts, input, flames, whatever else welcome. A lack of deadly silence
> would be especially appreciated :)

Well, the code is out there.  If there's time to try to get it in, I think it's
worth doing.

Best,
Rafael
