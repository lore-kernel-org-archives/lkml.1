Return-Path: <linux-kernel-owner+w=401wt.eu-S1752254AbYIJTcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254AbYIJTcZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 15:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754574AbYIJTcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 15:32:14 -0400
Received: from atlas.informatik.uni-freiburg.de ([132.230.150.3]:40263 "EHLO
	atlas.informatik.uni-freiburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754529AbYIJTcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 15:32:13 -0400
Date: Wed, 10 Sep 2008 21:32:11 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<ukleinek@informatik.uni-freiburg.de>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHSCRIPT] MAINTAINERS: sort and merge P and M fields
Message-ID: <20080910193210.GA26173@informatik.uni-freiburg.de>
Mail-Followup-To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <ukleinek@informatik.uni-freiburg.de>,
	Paul Bolle <pebolle@tiscali.nl>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20080908221139.GA10991@cassiopeia.tralala> <1221003422.3604.14.camel@test.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1221003422.3604.14.camel@test.thuisdomein>
User-Agent: Mutt/1.5.13 (2006-08-11)
Organization: Universitaet Freiburg, Institut f. Informatik
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Paul Bolle wrote:
> On Tue, 2008-09-09 at 00:11 +0200, Uwe Kleine-König wrote:
> > some time ago I sent two patch scripts to LKML that changed the
> > MAINTAINERS file.  One fixed the alphabetic ordering and another
> > merged the P and M fields to ease copy'n'paste.
> > 
> > See
> > 	http://thread.gmane.org/gmane.linux.kernel/702194
> > for the details.
> 
> If the MAINTAINERS file in the repository mentioned in that thread
> (http://www.modarm9.com/git/people/ukleinek/linux-2.6.git?a=shortlog;h=refs/heads/maintainers) is the result of the current script, you need to clean up some of the results of merging the P and M fields (false positives not removed):
No, it's not current, but your concerns are valid anyhow.

I updated my script to handle some of these entries, and I fixed the
others (and some more) by extra patches.

Now the URL above shows the current result again.

I will post the extra patches as a reply to this mail.

Thanks,
Uwe

-- 
Uwe Kleine-König

http://www.google.com/search?q=12+divided+by+3
