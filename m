Return-Path: <linux-kernel-owner+w=401wt.eu-S1752732AbYIVJjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbYIVJjx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 05:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbYIVJjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 05:39:45 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:46108 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751354AbYIVJjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 05:39:45 -0400
Date: Mon, 22 Sep 2008 11:39:43 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <ukleinek@strlen.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Paul Bolle <pebolle@tiscali.nl>
Subject: [RESEND] MAINTAINERS cleanup
Message-ID: <20080922093943.GA29310@strlen.de>
References: <20080908221139.GA10991@cassiopeia.tralala> <1221003422.3604.14.camel@test.thuisdomein> <20080910193210.GA26173@informatik.uni-freiburg.de> <20080912095851.GA3174@informatik.uni-freiburg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080912095851.GA3174@informatik.uni-freiburg.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I resend the last version of my MAINTAINERS cleanup series because I
didn't get any feedback last time but still consider it valuable.

It it freshly rebased on top of v2.6.27-rc7 and available on

	git://git.breakpoint.cc/ukleinek/linux-2.6 maintainers

an has the following changes listed below.  The first four commits were
done to allow merging P and M fields with the help of a script (i.e. the
sixth commit).  The remaining patch restores the alphabetic ordering in
the file (scripted).

If you fear merge conflicts or simply that new entries that don't follow the
new format, I can do a MAINTAINERS maintainership and sort out the
conflicts.

Best regards
Uwe

Uwe Kleine-König (6):
      MAINTAINERS: Remove a stale entry refering to kernel 2.2
      MAINTAINERS: add a realname for adilger@sun.com
      MAINTAINERS: remove real names from M fields
      MAINTAINERS: put corresponding realnames and mail addresses together
      MAINTAINERS: fix alphabetic ordering
      MAINTAINERS: merge P and M fields to ease copy'n'paste

 MAINTAINERS | 3130 ++++++++++++++++++++++-------------------------------------
 1 files changed, 1176 insertions(+), 1954 deletions(-)
