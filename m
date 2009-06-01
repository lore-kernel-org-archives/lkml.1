Return-Path: <linux-kernel-owner+w=401wt.eu-S1758444AbZFAUt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758444AbZFAUt7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 16:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755917AbZFAUtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 16:49:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56240 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755610AbZFAUtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 16:49:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jon Masters <jonathan@jonmasters.org>
Subject: Re: 2.6.30-rc7-git4: Reported regressions from 2.6.29
Date: Mon, 1 Jun 2009 22:50:20 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jonathan Corbet <corbet@lwn.net>
References: <4to6E2myxvG.A.muC.aIbIKB@chimera> <1243888117.31439.18.camel@localhost.localdomain>
In-Reply-To: <1243888117.31439.18.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906012250.20667.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 June 2009, Jon Masters wrote:
> On Sat, 2009-05-30 at 21:29 +0200, Rafael J. Wysocki wrote:
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13325
> > Subject		: 2.6.30-rc kills my box hard - and lockdep chains
> > Submitter	: Jonathan Corbet <corbet@lwn.net>
> > Date		: 2009-05-14 15:49 (17 days old)
> > References	: http://marc.info/?l=linux-kernel&m=124231630701394&w=4
> 
> Ingo's tree had a fix for this by increasing the lockdep chain size
> IIRC. I think it's worth updating the BZ with current info, Jon?

Well, I think this bug is supposed to have been fixed, but I'm not really sure.

That's why it's still listed.

Thanks,
Rafael
