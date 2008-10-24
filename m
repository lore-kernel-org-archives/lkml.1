Return-Path: <linux-kernel-owner+w=401wt.eu-S1757872AbYJXV4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872AbYJXV4w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 17:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754919AbYJXV4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 17:56:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48268 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507AbYJXV4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 17:56:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: 2.6.27-rc8 regression on arm: kernel will no longer boot on Sharp Zaurus c-3000
Date: Sat, 25 Oct 2008 00:01:03 +0200
User-Agent: KMail/1.9.9
Cc: Pavel Machek <pavel@suse.cz>, Stanislav Brabec <utx@penguin.cz>,
       kernel list <linux-kernel@vger.kernel.org>, rpurdie@rpsys.net,
       lenz@cs.wisc.edu, Dirk@opfer-online.de, arminlitzel@web.de,
       pavel.urban@ct.cz, metan@atrey.karlin.mff.cuni.cz,
       thommycheck@gmail.com, milan@ucw.cz
References: <20081009091929.GE29957@atrey.karlin.mff.cuni.cz> <20081015101747.GB28824@atrey.karlin.mff.cuni.cz> <20081015113923.GA21756@flint.arm.linux.org.uk>
In-Reply-To: <20081015113923.GA21756@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810250001.04835.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 15 of October 2008, Russell King wrote:
> On Wed, Oct 15, 2008 at 12:17:47PM +0200, Pavel Machek wrote:
> > Thanks for the effort, but it looks like it did not make it, right?
> 
> Correct - Linus was unpredictable and released 2.6.27 that evening,
> four days early giving me no time to push the fix to him.
> 
> However, it's gone in as part of the first ARM merge, so should be in
> -rc1.

Is it in -stable?  if not, is it considered as -stable material?

Rafael
