Return-Path: <linux-kernel-owner+w=401wt.eu-S1754341AbYAICGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341AbYAICGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 21:06:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751065AbYAICF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 21:05:57 -0500
Received: from ns.firmix.at ([62.141.48.66]:5441 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbYAICF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 21:05:56 -0500
Subject: Re: The ext3 way of journalling
From: Bernd Petrovitsch <bernd@firmix.at>
To: Tuomo Valkonen <tuomov@iki.fi>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <slrnfo7e3i.c37.tuomov@jolt.modeemi.cs.tut.fi>
References: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi>
	 <20080108164847.GA16462@skl-net.de>
	 <slrnfo7e3i.c37.tuomov@jolt.modeemi.cs.tut.fi>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Wed, 09 Jan 2008 03:05:51 +0100
Message-Id: <1199844352.16346.30.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.333 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.333 required=5
X-Spam-Score: -2.333 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for feeding the troll:

On Die, 2008-01-08 at 17:52 +0000, Tuomo Valkonen wrote:
> On 2008-01-08, Andre Noll <maan@systemlinux.org> wrote:
> > Use tune2fs to deactivate checking.
> 
> So, a workaround is the answer to a clear bug. Typical FOSS.

At least you get a simple solution for your problem: Configure your
system in a slightly different way (once!) and that's it.
There are far too many commercial vendors out there where you probably
wouldn't get an answer at all. And if, days or weeks later.

And if a - in your opinion! - wrong default value (for whatever reason)
is a bug in your universe, then you should probably adopt the
interpretation of words of this universe.
BTW changing the default value in the source now doesn't fix the
sub-optimal default value on your system.


> > Modify the init scripts or use another distro.
> 
> Another typical FOSS answer. "You have the source, you can fix it."
> With what time?

If you don't have the time to fix your problems, why should anyone else
have the time to fix your problems?

That is BTW the typical "i'm your customer and you have to obey me"
attitude. Perhaps you want to buy somewhere the time to fix your
problems.

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


