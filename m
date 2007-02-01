Return-Path: <linux-kernel-owner+w=401wt.eu-S1422763AbXBARse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422763AbXBARse (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 12:48:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422781AbXBARse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 12:48:34 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:35135 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422763AbXBARsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 12:48:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ukajmdDpAvORiNDswaALpYsS2yMGkwdMUQ715MhwSy4qMyM2TKOxuhp4qiEt3e6S8q5KBH/P/IPz8Y/je7pCKaF6OG2SARArS4CSP/tSc9RT5frj+K0XcJQVCjneACAxKt8gfKqzmdNQ1XA1PjEAl0c9RnFNrggd9dYqF3WI79k=
Message-ID: <f2b55d220702010948r16c48bdcsadc7c8492e36dd4e@mail.gmail.com>
Date: Thu, 1 Feb 2007 09:48:30 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Subject: Re: Free Linux Driver Development!
Cc: "Michael Buesch" <mb@bu3sch.de>, "Jeff Garzik" <jeff@garzik.org>,
       "Roland Dreier" <rdreier@cisco.com>, "Greg KH" <greg@kroah.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070201164201.GI7584@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070130012904.GA9617@kroah.com> <45BFC2CF.8010603@garzik.org>
	 <20070130222344.GF7584@csclub.uwaterloo.ca>
	 <200702011646.38762.mb@bu3sch.de>
	 <20070201164201.GI7584@csclub.uwaterloo.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/1/07, Lennart Sorensen <lsorense@csclub.uwaterloo.ca> wrote:
> Sometimes I might be.  At least on the days I have to deal with problems
> in Windows (it's not even my machine, so I don't get to pick what it
> runs all the time. :)  I haven't had particularly much luck getting a
> stable wireless going on linux yet, although I haven't put much effort
> into it yet either.  I figure in a couple of years there will be so many
> wifi devices around that wireless won't work anymore anyhow so it isn't
> a high priority.  I like simple trustworthy wires.

For what it's worth, hostap + Prism chips of various kinds has worked
quite solidly for 7-8 years or so, and I shipped handheld products
with it in 2001 or so and ran all of my wireless infrastructure gear
on it until I switched to off-the-shelf Broadcom- and Atheros-based
gear a couple of years ago (running OpenWRT and variants thereof).
The apparent inability of any wireless vendor to fix a low-level
firmware bug without breaking at least one common order of operations
in the driver API is hardly Linux's fault.

As it stands, there's enough of a learning and fiddling curve with
every WiFi driver that it's usually not very time-efficient to get
WiFi working under Linux on any single box that shipped with Windows.
But given a controlled configuration and some up-front time
investment, it's not that hard to switch over your local environment
(my neighbors and I have a WDS mesh set up), at which point you may be
the only people within RF range whose WiFi doesn't go belly-up when
some mangled frame comes along.  In this case, it's the last 20% of
the effort that produces 80% of the value.  (Bye-bye, telco monopoly;
the only live wires remaining into our house are the AC mains.)

Cheers,
- Michael
