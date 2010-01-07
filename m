Return-Path: <linux-kernel-owner+w=401wt.eu-S1753081Ab0AGF7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081Ab0AGF7i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 00:59:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751520Ab0AGF7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 00:59:37 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54299 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330Ab0AGF7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 00:59:37 -0500
Date: Thu, 7 Jan 2010 06:59:29 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.33-rc2: backtrace on unable to mount root
Message-ID: <20100107055929.GA11155@elf.ucw.cz>
References: <20100106073007.GD1392@ucw.cz>
 <201001070050.24404.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001070050.24404.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2010-01-07 00:50:24, Rafael J. Wysocki wrote:
> On Wednesday 06 January 2010, Pavel Machek wrote:
> > 
> > ...which is ugly, and did not happen before.
> 
> Any details?  What arch, what root fs, what hardware ...

Generic x86 (Intel based dell Dell), root fs could not be found
because driver was not available... I don't think this one is hw
dependend (try root=sda19, I guess that should reproduce it.)

It is really only consmetic problem, but...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
