Return-Path: <linux-kernel-owner+w=401wt.eu-S935008AbXHLWDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935008AbXHLWDZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 18:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760038AbXHLWDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 18:03:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59453 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759763AbXHLWDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 18:03:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Subject: Re: encrypted hibernation (was Re: Hibernation considerations)
Date: Mon, 13 Aug 2007 00:12:26 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, Vojtech Pavlik <vojtech@suse.cz>,
       seife@suse.de, LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       pm list <linux-pm@lists.linux-foundation.org>, david@lang.hm,
       Al Boldi <a1426z@gawab.com>
References: <200707151433.34625.rjw@sisk.pl> <20070805195628.GA1947@elf.ucw.cz> <20070811234356.GA19183@gallifrey>
In-Reply-To: <20070811234356.GA19183@gallifrey>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708130012.27412.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 12 August 2007 01:43, Dr. David Alan Gilbert wrote:
> * Pavel Machek (pavel@ucw.cz) wrote:
> > Hi!
> > 
> > > > > Two things which I think would be nice to consider are:
> > > > >    1) Encryption - I'd actually prefer if my luks device did not
> > > > >        remember the key accross a hibernation;

Why exactly (assuming that the hibernation image is encrypted)?

Greetings,
Rafael
