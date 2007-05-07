Return-Path: <linux-kernel-owner+w=401wt.eu-S933675AbXEGMwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933675AbXEGMwa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 08:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933691AbXEGMwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 08:52:30 -0400
Received: from ns1.suse.de ([195.135.220.2]:50117 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933675AbXEGMwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 08:52:30 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: Back to the future.
Date: Mon, 7 May 2007 14:52:19 +0200
User-Agent: KMail/1.9.1
Cc: David Lang <david.lang@digitalinsight.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <Pine.LNX.4.63.0705061909290.19118@qynat.qvtvafvgr.pbz> <20070507124818.GA18209@elf.ucw.cz>
In-Reply-To: <20070507124818.GA18209@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705071452.21969.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 7. Mai 2007 14:48 schrieb Pavel Machek:
> > >Including network? Your tcp peers will be really confused, then, if
> > >you ACK packets then claim you did not get them. No, you do not want
> > >to start network.
> > 
> > anyone who is doing a hibernate or suspend who expect all the network 
> > connections to be working afterwords is dreaming or smokeing
> >something.
> 
> Really? It works today... if the suspend is short enough. And that's
> how it should be.

If we get very good at Wake-on-Lan it should work for any length
of time.

	Regards
		Oliver

