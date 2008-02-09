Return-Path: <linux-kernel-owner+w=401wt.eu-S1757034AbYBIBAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034AbYBIBAY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 20:00:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754841AbYBIBAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 20:00:10 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:47812 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768AbYBIBAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 20:00:09 -0500
Date: Fri, 8 Feb 2008 16:57:38 -0800
From: Greg KH <greg@kroah.com>
To: Greg KH <gregkh@suse.de>
Cc: "S.??a??lar Onur" <caglar@pardus.org.tr>, "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>, torvalds@linux-foundation.org,
       Justin Forbes <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Dave Jones <davej@redhat.com>, akpm@linux-foundation.org,
       Chuck Wolber <chuckw@quantumlinux.com>, stable@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 00/45] 2.6.24-stable review
Message-ID: <20080209005738.GA23276@kroah.com>
References: <20080207204549.GA16389@suse.de> <200802072341.44001.caglar@pardus.org.tr> <20080207215834.GA19117@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080207215834.GA19117@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2008 at 01:58:34PM -0800, Greg KH wrote:
> On Thu, Feb 07, 2008 at 11:41:42PM +0200, S.??a??lar Onur wrote:
> > Hi;
> > 
> > 07 ??ub 2008 Per tarihinde, Greg KH ??unlar?? yazm????t??: 
> > > This is the start of the stable review cycle for the 2.6.24.1 release.
> > > There are 45 patches in this series, all will be posted as a response to
> > > this one.  If anyone has any issues with these being applied, please let
> > > us know.  If anyone is a maintainer of the proper subsystem, and wants
> > > to add a Signed-off-by: line to the patch, please respond with it.
> > 
> > If its possible could you please add [1] "mac80211: hardware scan rework" and [2] "mac80211: Restore rx.fc before every invocation of ieee80211_invoke_rx_handlers" into -stable too?
> > 
> > [1] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=ece8edddf067d21c4e5abfe3f1205da1588edbb2
> > [2] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=69f817b654d683265118188bbfb8bc0d8978cce6
> 
> I can queue them up for the next one after this release.

In looking at these, I would rather that either the wireless maintainer,
or the network maintainer send these too us, to verify that they are
needed, and the backport works properly.

So please go ask them to send these in.

thanks,

greg k-h
