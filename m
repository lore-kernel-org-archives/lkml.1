Return-Path: <linux-kernel-owner+w=401wt.eu-S1757288AbYDLTMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288AbYDLTMM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 15:12:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755836AbYDLTL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 15:11:57 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4131 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755668AbYDLTL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 15:11:57 -0400
Date: Sat, 12 Apr 2008 21:11:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Andrew Morton <akpm@osdl.org>
Subject: Re: [linux-pm] s2ram: warn when interrupts should be disabled but are not
Message-ID: <20080412191151.GA4212@ucw.cz>
References: <20080412095311.GA1729@elf.ucw.cz> <Pine.LNX.4.44L0.0804121135350.10697-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0804121135350.10697-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2008-04-12 11:36:32, Alan Stern wrote:
> On Sat, 12 Apr 2008, Pavel Machek wrote:
> 
> > ---
> > commit fc3bccaf69e6c05464e7154369639bd5c96ccdc1
> > tree bf960093ddb840242a00b4ec456ec79472b1c2ad
> > parent 308e9d5309f378209e931f63f729806ec0a4d9f1
> > author Pavel <pavel@amd.ucw.cz> Sat, 12 Apr 2008 11:52:05 +0200
> > committer Pavel <pavel@amd.ucw.cz> Sat, 12 Apr 2008 11:52:05 +0200
> > 
> >  drivers/ata/ahci.c |    2 +-
> >  drivers/base/sys.c |    3 +++
> >  2 files changed, 4 insertions(+), 1 deletions(-)
> 
> What happened to the drivers/ata/ahci.c part of the patch?

Sorry, bad diffstat (but correct patch).

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
