Return-Path: <linux-kernel-owner+w=401wt.eu-S1756917AbYCVRyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917AbYCVRyQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 13:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754702AbYCVRyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 13:54:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47184 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754755AbYCVRyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 13:54:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc6-git6: Reported regressions from 2.6.24
Date: Sat, 22 Mar 2008 18:53:42 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>,
       Jeff Garzik <jeff@garzik.org>
References: <200803220259.48534.rjw@sisk.pl> <20080321223315.3e0e042f.akpm@linux-foundation.org> <20080322111535.GC13264@elte.hu>
In-Reply-To: <20080322111535.GC13264@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803221853.43669.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 22 of March 2008, Ingo Molnar wrote:
> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > ...
> > > 
> > > Date		: 2007-11-19 14:43 (124 days old)
> 
> btw., this one appears to be an accounting artifact: two regressions 
> with similar (same?) symptoms in the same bugzilla. The first regression 
> was resolved after 7 days, the second was reopened 10 days ago. (It 
> could easily be about the same underlying (hw?) problem, but the 
> regression window for users was very small.)

Hm, perhaps we should create another bugzilla entry for the problem
described in http://bugzilla.kernel.org/show_bug.cgi?id=9412#c5.

If that turns out to be a duplicate of bug #9412, it'll be easy to close.
Otherwise, it's just _very_ confusing.

Thanks,
Rafael
