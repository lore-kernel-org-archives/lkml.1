Return-Path: <linux-kernel-owner+w=401wt.eu-S1755329AbZB0N2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329AbZB0N2R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 08:28:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757441AbZB0N1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 08:27:49 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44536 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757341AbZB0N1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 08:27:48 -0500
Date: Fri, 27 Feb 2009 14:27:40 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jean Delvare <khali@linux-fr.org>
Cc: Hans de Goede <hdegoede@redhat.com>, Matthew Garrett <mjg@redhat.com>,
       Len Brown <lenb@kernel.org>, Luca Tettamanti <kronos.it@gmail.com>,
       Thomas Renninger <trenn@suse.de>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: add "auto" to acpi_enforce_resources
Message-ID: <20090227132740.GF1482@ucw.cz>
References: <alpine.LFD.2.00.0902040042570.9833@localhost.localdomain> <20090204060513.GA28321@srcf.ucam.org> <498953DF.5050306@redhat.com> <20090204131708.GA2739@srcf.ucam.org> <20090204142606.1823661b@hyperion.delvare> <20090204142015.GB3923@srcf.ucam.org> <20090210145716.105ab58b@hyperion.delvare> <20090210140829.GA25397@srcf.ucam.org> <49919E08.5050002@redhat.com> <20090210172408.400cacee@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090210172408.400cacee@hyperion.delvare>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > For the record we have changed the default to strict in Fedora's 
> > development branch, for 2 weeks or so now, including in the recently 
> > released Fedora 11 release and we've had 0 complaints so far.
> 
> Well, if the number of affected systems is small, this is good news.
> But this is only 2 weeks and one distribution, coverage isn't
> sufficient to claim anything yet IMHO.
> 
> That being said... if there's a common consensus that switching to
> strict and dealing with fallouts is the best thing to do, and I'm the
> only one objecting to this, then I am ready to admit that I was wrong
> and let you proceed.

I believe that 'enable strict, deal with fallout' is the best
long-term strategy...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
