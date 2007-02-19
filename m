Return-Path: <linux-kernel-owner+w=401wt.eu-S1161087AbXBTXXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161087AbXBTXXy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 18:23:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161088AbXBTXXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 18:23:50 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:48068 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161081AbXBTXXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 18:23:32 -0500
Date: Mon, 19 Feb 2007 23:31:16 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>,
       Nigel Cunningham <ncunningham@linuxmail.org>,
       Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Documentation: Ask driver writers to provide PM support
Message-ID: <20070219223116.GB21199@elf.ucw.cz>
References: <200702192311.36710.rjw@sisk.pl> <200702192319.49265.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702192319.49265.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2007-02-19 23:19:48, Rafael J. Wysocki wrote:
> On Monday, 19 February 2007 23:11, Rafael J. Wysocki wrote:
> > Add a paragraph in Documentation/SubmittingDrivers requesting that the
> > basic PM support be provided by new device drivers.
> 
> Ouch.  There was a wrong file name in the SubmittingDrivers patch, sorry.
> 
> ---
> Add a paragraph in Documentation/SubmittingDrivers requesting that the
> basic PM support be provided by new device drivers.
> 
> Add two new documents in Documentation/power/ giving general instructions on
> debugging the suspend/resume functionality and testing the suspend and resume
> support in device drivers.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Looks ok to me.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
