Return-Path: <linux-kernel-owner+w=401wt.eu-S1752154AbXBJXP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbXBJXP1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 18:15:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbXBJXP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 18:15:27 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:3029 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127AbXBJXPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 18:15:25 -0500
Date: Sat, 10 Feb 2007 17:41:11 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Pavel Roskin <proski@gnu.org>
Cc: Theodore Tso <tytso@mit.edu>, James Ketrenos <jketreno@linux.intel.com>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       ipw3945-devel@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [ipw3945-devel] [ANNOUNCE] d80211 based driver for Intel PRO/Wireless 3945ABG
Message-ID: <20070210224111.GA24027@tuxdriver.com>
References: <45CCE3CA.4050904@linux.intel.com> <20070210162254.GC25607@thunk.org> <20070210163933.GA17140@tuxdriver.com> <20070210125351.05uo0o0sgw0w0ckc@webmail.spamcop.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070210125351.05uo0o0sgw0w0ckc@webmail.spamcop.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 10, 2007 at 12:53:51PM -0500, Pavel Roskin wrote:
> Quoting "John W. Linville" <linville@tuxdriver.com>:
> 
> > > Very cool!  Is it likely that d80211 and iwlwifi will be pushed into
> > > mainline in time for 2.6.21?
> >
> > Hmmm...I think we need to spend a cycle or so in -mm.  2.6.22 seems
> > more likely for mainline.
> 
> I think we should take this as a goal.  Last time I checked, d80211 wasn't in
> -mm.  Perhaps it should go there.  And by the way, the latest changes from
> netdev->class_dev to netdev->dev break d80211.  Perhaps we should rebase
> wireless-dev immediately after 2.6.21-rc1, fix all compile issues and submit
> the patch to -mm.

That is basically the plan. :-)

John
-- 
John W. Linville
linville@tuxdriver.com
