Return-Path: <linux-kernel-owner+w=401wt.eu-S1763125AbXFAVfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763125AbXFAVfI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 17:35:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759162AbXFAVe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 17:34:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57718 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504AbXFAVe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 17:34:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Olaf Dietsche <olaf+list.linux-acpi@olafdietsche.de>
Subject: Re: [2.6.22-rc3][ACPI?] Resume from s2r doesn't work.
Date: Fri, 1 Jun 2007 23:40:53 +0200
User-Agent: KMail/1.9.5
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>
References: <878xb35sje.fsf@goat.bogus.local> <200706012237.17375.rjw@sisk.pl> <87k5un4bwk.fsf@goat.bogus.local>
In-Reply-To: <87k5un4bwk.fsf@goat.bogus.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706012340.54394.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 1 June 2007 23:12, Olaf Dietsche wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > On Friday, 1 June 2007 22:27, Olaf Dietsche wrote:
> >> When I resume, everything seems to come up (fan becomes busy, disk and
> >> dvd spin up for a short time),
> >
> > Hmm, what about the screen?
> 
> When the laptop is dead, screen remains black.
> 
> When I skip acpi_enter_sleep_state(), the screen works like everything
> else.

I think you should try s2ram (http://en.opensuse.org/s2ram) as the first step.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
