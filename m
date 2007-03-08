Return-Path: <linux-kernel-owner+w=401wt.eu-S933059AbXCHTCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933059AbXCHTCm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 14:02:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933063AbXCHTCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 14:02:42 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:4226 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933059AbXCHTCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 14:02:41 -0500
Date: Thu, 8 Mar 2007 13:34:04 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc3-mm1
Message-ID: <20070308183404.GC5323@tuxdriver.com>
References: <20070307201839.6f45735b.akpm@linux-foundation.org> <200703081756.l28HuwDD016018@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703081756.l28HuwDD016018@turing-police.cc.vt.edu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2007 at 12:56:58PM -0500, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 07 Mar 2007 20:18:39 PST, Andrew Morton said:
> >   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc3/2.6.21-rc3-mm1/
> 
> Mostly working for me.
> 
> > - The wireless changes in here need a lot of testers, please.  It is major
> >   rework.
> 
> Working on it - the new MAC80211 stack landed in the -mm tree, but the matching
> iwlwifi driver for the Intel 3945ABG is still out-of-tree and acting wonky
> for me.  The card comes up, 'iwlist scanning' sees 4 access points, but it
> won't associate.  Not sure what I borked up.

FWIW, I have had best results w/ that driver by manually selecting
the freq and ap as well as essid.

Hth!

John
-- 
John W. Linville
linville@tuxdriver.com
