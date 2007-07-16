Return-Path: <linux-kernel-owner+w=401wt.eu-S1764289AbXGPPRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764289AbXGPPRx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 11:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756323AbXGPPRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 11:17:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43256 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755163AbXGPPRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 11:17:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Hibernation considerations
Date: Mon, 16 Jul 2007 17:25:15 +0200
User-Agent: KMail/1.9.5
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>, david@lang.hm,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Al Boldi <a1426z@gawab.com>
References: <Pine.LNX.4.44L0.0707161013440.3410-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0707161013440.3410-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707161725.16593.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 16 July 2007 16:15, Alan Stern wrote:
> On Mon, 16 Jul 2007, Nigel Cunningham wrote:
> 
> > > As I understand it, running a different OS between the hibernate and 
> > > the resume would violate the ACPI spec.
> > 
> > Well then, I know one or two people who would argue that the ACPI spec is 
> > faulty. :\
> 
> It's hard to argue against that.  In fact there are people who would 
> argue that the ACPI spec is incomplete and inconsistent period, 
> regardless of any questions about what happens between hibernate and 
> resume.  :-)

That's true, but OTOH it's difficult to argue with my notebook's firmware
about that. ;-)

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
