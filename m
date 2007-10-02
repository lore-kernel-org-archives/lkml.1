Return-Path: <linux-kernel-owner+w=401wt.eu-S1753108AbXJBJOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108AbXJBJOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 05:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbXJBJOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 05:14:06 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:49600 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbXJBJOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 05:14:05 -0400
Date: Tue, 2 Oct 2007 11:14:04 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Rob Landley <rob@landley.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, rjw@sisk.pl
Subject: Re: [PATCH] Add Documentation/power/00-INDEX
Message-ID: <20071002091404.GD32044@atrey.karlin.mff.cuni.cz>
References: <200710012244.46869.rob@landley.net> <20071002071022.GA29559@atrey.karlin.mff.cuni.cz> <200710020348.03470.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710020348.03470.rob@landley.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > +swsusp.txt
> > > +	- Goals, implementation, and usage of software suspend (ACPI S3)
> >
> > But please delete (ACPI S3) remark. It is ACPI S4, if anything.
> > 								Pavel
> 
> I got that from Documentation/power/video.txt, which starts "Video issues with 
> S3 resume".  Is it correct in that file?

Yes... video.txt talks about suspend-to-ram issues (aka ACPI S3),
while swsusp.txt talks about hibernate-to-disk issues (aka ACPI S4).

> I've removed it from the patch in http://landley.net/kdocs/make/patches

Thanks!
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
