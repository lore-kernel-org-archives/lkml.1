Return-Path: <linux-kernel-owner+w=401wt.eu-S1750935AbXCCHxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750935AbXCCHxp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 02:53:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751109AbXCCHxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 02:53:45 -0500
Received: from mail.kroah.org ([69.55.234.183]:36380 "EHLO perch.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935AbXCCHxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 02:53:44 -0500
Date: Fri, 2 Mar 2007 23:48:04 -0800
From: Greg KH <gregkh@suse.de>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Chuck Ebbert <cebbert@redhat.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>
Subject: Re: [patch 0/9] 2.6.19-stable review
Message-ID: <20070303074804.GA13613@suse.de>
References: <20070227000538.GA6283@kroah.com> <45E49329.5080509@linuxtv.org> <20070303012300.GD6496@suse.de> <45E8D406.7010008@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45E8D406.7010008@linuxtv.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2007 at 08:48:54PM -0500, Michael Krufky wrote:
> 
> The dvbdev patch is pretty important, fixes a horrible problem, although the case for
> it to occur is rare.  The other two patches are of the "obviously correct - minimal change" 
> type.
> 
> If it isnt too much trouble, then yes, it is worth it to push a new release because of the
> dvbdev patch.
> 
> However, please chop the "backported from" and "cherry picked from" lines from those patches.
> I cherry-picked them from Mauro's tree, but he wiped it out and re-pushed those changes in
> before Linus merged them....  so, the actual changesets in Linus' tree have different hashes.
> 
> (i removed those old hashes from the patches that I posted on linuxtv.org)

I picked up the new patches and did a new release.

> As for the 2.6.20.y patches, should I email those to you inline or can you just grab them from
> the linuxtv.org www server?  ( http://linuxtv.org/~mkrufky/stable/2.6.20.y/ )

Email is usually better, as that's what my scripts are set up to handle.

thanks,

greg k-h
