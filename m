Return-Path: <linux-kernel-owner+w=401wt.eu-S1757486AbXGaJ5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486AbXGaJ5z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 05:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753685AbXGaJ5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 05:57:48 -0400
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:37847
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbXGaJ5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 05:57:47 -0400
Date: Tue, 31 Jul 2007 02:57:23 -0700
To: Carlo Florendo <subscribermail@gmail.com>
Cc: Martin Steigerwald <Martin@lichtvoll.de>, ck@vds.kolivas.org,
       Satyam Sharma <satyam@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: [ck] Re: Linus 2.6.23-rc1
Message-ID: <20070731095723.GH32582@gnuppy.monkey.org>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <200707292023.36555.Martin@lichtvoll.de> <alpine.LFD.0.999.0707300008230.30928@enigma.security.iitk.ac.in> <200707292118.45484.Martin@lichtvoll.de> <46AE8D25.20602@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46AE8D25.20602@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2007 at 09:15:17AM +0800, Carlo Florendo wrote:
> And I think you are digressing from the main issue, which is the empirical 
> comparison of SD vs. CFS and to determine which is best.   The root of all 
> the scheduler fuss was the emotional reaction of SD's author on why his 
> scheduler began to be compared with CFS.

Legitimate emotional reaction for being locked out of the development
process. There's a very human aspect to this, yes, a negative human
aspect that pervade Linux kernel development and is overly defensive and
protective of new ideas.

> We obviously all saw how the particular authors tried to address the 
> issues.  Ingo tried to address all concerns while Con simply ranted about 
> his scheduler being better.  If this is what you think about being a bit 
> more human, then I think that this has no place in the lkml.

That's highly inaccurate and rather disrespect of Con's experience.
There as a policy decision made with SD that one person basically didn't
like, this person whined like a baby for the a formula bottle and didn't
understand how to use "nice" to control this inherent behavior of this
scheduler.

bill

