Return-Path: <linux-kernel-owner+w=401wt.eu-S932778AbXDFWRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932778AbXDFWRa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 18:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933175AbXDFWRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 18:17:30 -0400
Received: from www.osadl.org ([213.239.205.134]:42440 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932778AbXDFWR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 18:17:29 -0400
Subject: Re: coding style for long conditions (WAS: Re: [PATCH 25/90] ...
	blinky leds!!)
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: David Brownell <david-b@pacbell.net>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200704061405.50169.david-b@pacbell.net>
References: <11757099691323-git-send-email-tony@atomide.com>
	 <200704061029.55710.david-b@pacbell.net>
	 <46169968.2050006@s5r6.in-berlin.de>
	 <200704061405.50169.david-b@pacbell.net>
Content-Type: text/plain
Date: Sat, 07 Apr 2007 00:17:56 +0200
Message-Id: <1175897876.28263.490.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David,

On Fri, 2007-04-06 at 14:05 -0700, David Brownell wrote:
> Please change your coding style to conform to Documentation/CodingStyle.
> 
> 	***	Only indent with tabs!!		***
> 
> Every one of those examples violates that simple rule.
> 
> Why does *anyone* have even the slightest difficulty understanding such a
> simple rule?  I realize that two of those words have more than a single
> syllable, but that should not be a problem.  Even EMACS is trainable.

please stop to be more Catholic than the Pope.

commit  0aa599c5644fddd3052433c5335260108a8a39a2
drivers/usb/net/usbnet.h

http://tglx.de/private/tglx/usbnet.png

/me recommends emacs-develock.el for colorful white space wreckage
display !

You probably want to look at more files contributed by david-b before
you look at mine :)

	tglx


