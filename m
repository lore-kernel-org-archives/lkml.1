Return-Path: <linux-kernel-owner+w=401wt.eu-S936764AbXG2V2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936764AbXG2V2R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 17:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935631AbXG2V2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 17:28:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49444 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935598AbXG2V2A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 17:28:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: [PATCH 2/2] Introduce CONFIG_SUSPEND
Date: Sun, 29 Jul 2007 23:36:54 +0200
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Len Brown <lenb@kernel.org>, david@lang.hm,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200707251238.50218.lenb@kernel.org> <200707292317.21419.rjw@sisk.pl> <20070729211824.GL16817@stusta.de>
In-Reply-To: <20070729211824.GL16817@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707292336.55588.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 29 July 2007 23:18, Adrian Bunk wrote:
> On Sun, Jul 29, 2007 at 11:17:20PM +0200, Rafael J. Wysocki wrote:
> > On Sunday, 29 July 2007 22:40, Adrian Bunk wrote:
> > > On Sun, Jul 29, 2007 at 02:38:05PM +0200, Rafael J. Wysocki wrote:
> > > >...
> > > > +config SUSPEND
> > > > +	bool "Suspend"
> > >              "Suspend to RAM"
> > 
> > Not only.  This also includes "standby".
> 
> Whatever it includes - please tell it to the user in the prompt.
> 
> Technical issues are important, but it's often forgotten how many 
> problems people run into because the description of a kconfig option 
> could have been better.

Sure.  Please see the updated patch I've just sent. :-)

Greetings,
Rafael
