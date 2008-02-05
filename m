Return-Path: <linux-kernel-owner+w=401wt.eu-S1755384AbYBEMc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbYBEMc4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 07:32:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754686AbYBEMcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 07:32:47 -0500
Received: from ns.firmix.at ([62.141.48.66]:4382 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099AbYBEMcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 07:32:45 -0500
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
From: Bernd Petrovitsch <bernd@firmix.at>
To: David Newall <davidn@davidnewall.com>
Cc: Greg KH <greg@kroah.com>, Christer Weinigel <christer@weinigel.se>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <courier.47A845EF.0000444D@hawking.rebel.net.au>
References: <20080125180232.GA4613@kroah.com>
	 <20080202123710.42df1aa0@weinigel.se> <20080202191930.GA19826@kroah.com>
	 <47A5D895.20300@davidnewall.com> <1202205358.9770.18.camel@tara.firmix.at>
	 <courier.47A845EF.0000444D@hawking.rebel.net.au>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Tue, 05 Feb 2008 13:32:37 +0100
Message-Id: <1202214757.9770.57.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.328 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.328 required=5
X-Spam-Score: -2.328 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Die, 2008-02-05 at 21:48 +1030, David Newall wrote:
> Bernd Petrovitsch writes: 
> > On Mon, 2008-02-04 at 01:37 +1030, David Newall wrote:
> > [...]
> >> disadvantage Linux with respect to many classes of devices, for example
> >> GSM transceivers when used in those parts of the world^ where regulatory
> >> requirements prohibit modification of power or frequency settings, which
> >> effectively prohibits open-source driver.

BTW the (trivial?) solution for the hardware manufacturer: People must
use/download some signed binary blurb which actually configures the
limits of the configurable values.

> > Are you sure that that is not only (the results of) propaganda of
> > (certain) proprietary companies?
> 
> well, yes. 
>
> > Usually the *user* (at home, wherever) sets "illegal" values. So it's
> > the users responsibility and the manufacturer, importer or sellers don't
> > care (if only that can't prevent other "illegal" actions like "beating
> > some to death with $WLAN_ROUTER").
> 
> Or, as is the case perhaps almost everywhere, governments prohibit devices 

There are rumors/stories that even the FCC in .us doesn't go after
producers/vendors/sellers of devices which may be operated beyond
governmental requirements. With exactly my comparison BTW.
Does the FCC forbid the *operating* or the *distribution*?

> that can operate outside of local requirements. 

At least in .at it is not forbidden to import and/or sell devices which
*can* be operated outside some local law requirements. If *you*
configure it wrong, *you* have violated the law/rules and it is thus in
*your* responsibility.

The first reason is that there are European Union laws which basically
override the local Austrian laws - but we can ignore that as it is a
European Union thing.

One (non-technical) reason is that even those requirements change over
time.

Another reason is that e.g. setting the transmit power on some common
WLAN devices to the minimal possible values (which the hardware allows)
doesn't imply staying within legal bounds: I can have a (common of the
shelf!) high-quality antenna and not-so-bad cabling and than I'm beyond
the officially allowed maximum transmit power.

A third (non-technical) reason is that I (as a pure private
person/organization) may have some explicit governmental exception of
the governmental limits (for whatever reason).

I concur that there might be governments which forbid
importing/selling/distributing devices where legal usage is absolutely
not possible.
But historically at least in .at, these devices were simply marked "for
export only". "Problem" solved.

> > Or do you get a gun manufacturer before court just because someone
> > committed a crime with a its gun?
> 
> Let's not confuse the issue.

It's IMHO precisely the issue (at least with my understanding of law
stuff): Which action is illegal and who is responsible for it.

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


