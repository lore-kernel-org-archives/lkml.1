Return-Path: <linux-kernel-owner+w=401wt.eu-S1765459AbXHLD0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765459AbXHLD0Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 23:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755760AbXHLD0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 23:26:00 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:47826 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754316AbXHLD0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 23:26:00 -0400
Date: Sun, 12 Aug 2007 05:27:17 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Andi Kleen <andi@firstfloor.org>,
       =?iso-8859-1?Q?Hans-J=FCrgen?= Koch <hjk@linutronix.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Documentation files in html format?
Message-ID: <20070812032717.GA13141@uranus.ravnborg.org>
References: <20070809113122.3aa508e4@oldman.hamilton.local> <200708091508.20626.hjk@linutronix.de> <p73hcn8g25m.fsf@bingen.suse.de> <20070810074047.GC31307@uranus.ravnborg.org> <46BC6DA9.1050903@s5r6.in-berlin.de> <20070810201235.GA4133@uranus.ravnborg.org> <20070811201151.c25261cf.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070811201151.c25261cf.rdunlap@xenotime.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Sam,
> 
> Sorry for the late question (I've been away :).
> 
> Was your makefiles.txt conversion done totally by hand?
Yes. A few search&replace, the rest manual.

> Could it be automated?
For text with a unifom structure like makefiles.txt - yes.

	Sam
