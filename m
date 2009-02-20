Return-Path: <linux-kernel-owner+w=401wt.eu-S1753764AbZBTSWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764AbZBTSWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 13:22:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbZBTSWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 13:22:32 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38919 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbZBTSWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 13:22:31 -0500
Date: Fri, 20 Feb 2009 19:22:15 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Arjan van de Ven <arjan@infradead.org>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Arve Hj?nnev?g <arve@android.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090220182213.GA1681@ucw.cz>
References: <f73f7ab80902161208h12837d4ex1d28d55d031d5d71@mail.gmail.com> <13B9B4C6EF24D648824FF11BE896716203771DD01B@dlee02.ent.ti.com> <20090216145948.6fea81c3@infradead.org> <200902170019.40599.rjw@sisk.pl> <20090216232329.GA15678@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090216232329.GA15678@srcf.ucam.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On Mon 2009-02-16 23:23:30, Matthew Garrett wrote:
> On Tue, Feb 17, 2009 at 12:19:38AM +0100, Rafael J. Wysocki wrote:
> 
> > This, again, seems to be a bit x86-centric. :-)  The Android people are telling
> > us that on the hardware they deal with it does make sense to put the entire
> > system to sleep even for relatively short periods of time, since the latencies
> > involved are not too bad.
> 
> Arve said that the power state was equivalent in idle and suspend, but 

...for Arve's hardware. Not all embedded systems are like that, and
OLPC / PCs are definitely not like that.

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
