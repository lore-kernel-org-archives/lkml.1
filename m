Return-Path: <linux-kernel-owner+w=401wt.eu-S1756652AbYBHWLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652AbYBHWLV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 17:11:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758404AbYBHWIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 17:08:17 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:33498 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760733AbYBHWIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 17:08:15 -0500
Date: Fri, 8 Feb 2008 23:08:34 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
Subject: Re: [rft] s2ram wakeup moves to .c, could fix few machines
Message-ID: <20080208220834.GA1631@elf.ucw.cz>
References: <20080205190600.GB11613@elf.ucw.cz> <47AB887E.7010000@zytor.com> <20080208215809.GN12923@elf.ucw.cz> <200802082301.51582.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802082301.51582.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-02-08 23:01:51, Rafael J. Wysocki wrote:
> On Friday, 8 of February 2008, Pavel Machek wrote:
> > Hi!
> > 
> > Rafael, this is for you.
> 
> Thanks.
> 
> > My cleanups, relative to your cleanup patch. You may need manual patching
> > around rep/stosd.
> 
> OK, I'll try to merge it.

For the record, now it is even tested on 32-bit and test-compiled on
64-bit.

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
