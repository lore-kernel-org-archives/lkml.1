Return-Path: <linux-kernel-owner+w=401wt.eu-S934002AbYBGWBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934002AbYBGWBA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 17:01:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933715AbYBGWAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 17:00:44 -0500
Received: from mx1.suse.de ([195.135.220.2]:57524 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933626AbYBGWAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 17:00:43 -0500
Date: Thu, 7 Feb 2008 13:58:34 -0800
From: Greg KH <gregkh@suse.de>
To: "S.??a??lar Onur" <caglar@pardus.org.tr>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/45] 2.6.24-stable review
Message-ID: <20080207215834.GA19117@suse.de>
References: <20080207204549.GA16389@suse.de> <200802072341.44001.caglar@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802072341.44001.caglar@pardus.org.tr>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2008 at 11:41:42PM +0200, S.??a??lar Onur wrote:
> Hi;
> 
> 07 ??ub 2008 Per tarihinde, Greg KH ??unlar?? yazm????t??: 
> > This is the start of the stable review cycle for the 2.6.24.1 release.
> > There are 45 patches in this series, all will be posted as a response to
> > this one.  If anyone has any issues with these being applied, please let
> > us know.  If anyone is a maintainer of the proper subsystem, and wants
> > to add a Signed-off-by: line to the patch, please respond with it.
> 
> If its possible could you please add [1] "mac80211: hardware scan rework" and [2] "mac80211: Restore rx.fc before every invocation of ieee80211_invoke_rx_handlers" into -stable too?
> 
> [1] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=ece8edddf067d21c4e5abfe3f1205da1588edbb2
> [2] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=69f817b654d683265118188bbfb8bc0d8978cce6

I can queue them up for the next one after this release.

thanks,

greg k-h
