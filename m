Return-Path: <linux-kernel-owner+w=401wt.eu-S1760967AbXGEJdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760967AbXGEJdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 05:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759079AbXGEJcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 05:32:53 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35366 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758620AbXGEJcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 05:32:52 -0400
Date: Thu, 5 Jul 2007 11:32:51 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Paul Mackerras <paulus@samba.org>
Cc: Adrian Bunk <bunk@stusta.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: The big suspend mess
Message-ID: <20070705093251.GB3228@elf.ucw.cz>
References: <20070703042916.GA17240@srcf.ucam.org> <200707031456.40890.rjw@sisk.pl> <1183497290.3388.4.camel@localhost.localdomain> <200707032332.49694.rjw@sisk.pl> <18059.5165.861038.392332@cargo.ozlabs.ibm.com> <20070704221952.GM3492@stusta.de> <20070705002747.GA2952@elf.ucw.cz> <18060.16657.2143.11489@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18060.16657.2143.11489@cargo.ozlabs.ibm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2007-07-05 10:53:37, Paul Mackerras wrote:
> Pavel Machek writes:
> 
> > 0. Get someone to sign up as a maintainer for suspend, so we have
> > someone to blame for the mess? :-)
> 
> I thought that was Rafael?

Rafael is good job trying to fix suspend when he can, but we do not
actually have "SUSPEND" entry in MAINTAINERS file.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
