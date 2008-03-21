Return-Path: <linux-kernel-owner+w=401wt.eu-S1758778AbYCUA2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778AbYCUA2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 20:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbYCUA2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 20:28:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38137 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbYCUA2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 20:28:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Subject: Re: APM lockups since 2.6.25
Date: Fri, 21 Mar 2008 01:27:56 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0803191608500.25941@artax.karlin.mff.cuni.cz> <200803201131.25828.rjw@sisk.pl> <Pine.LNX.4.64.0803210059440.2540@artax.karlin.mff.cuni.cz>
In-Reply-To: <Pine.LNX.4.64.0803210059440.2540@artax.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803210127.56437.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 21 of March 2008, Mikulas Patocka wrote:
> Hi

Hi,
  
> > > I have an old notebook with APM and I am experiencing occasional APMD 
> > > lockups after resume, with kernels 2.6.25rc1 snd 2.6.25rc3. They didn't 
> > > happen with 2.6.24 or before.
> > > 
> > > The bug happens about once a week or so.
> > > 
> > > If you have any idea how to debug it, you can send me a test code.
> > 
> > It is possible that the bug was fixed in -rc4.  Can you please test -rc6 and
> > see if it's still present?
> > 
> > Thanks,
> > Rafael
> 
> I'm now running on -rc6, so I'll see (it takes some days for the bug to 
> appear). Where is that patch that went to -rc4 and that may fix it?

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=7a8d37a37380e2b1500592d40b7ec384dbebe7a0

Thanks,
Rafael
