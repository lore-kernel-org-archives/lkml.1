Return-Path: <linux-kernel-owner+w=401wt.eu-S1759360AbYB1PDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759360AbYB1PDz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 10:03:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754350AbYB1PDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 10:03:46 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:4929 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754156AbYB1PDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 10:03:45 -0500
Date: Thu, 28 Feb 2008 09:41:58 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Aurelien Jarno <aurelien@aurel32.net>
Cc: Michael Buesch <mb@bu3sch.de>, Adrian Bunk <bunk@kernel.org>,
       Larry Finger <Larry.Finger@lwfinger.net>, ralf@linux-mips.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [SSB] PCI core driver: use new SPROM data structure
Message-ID: <20080228144158.GC3063@tuxdriver.com>
References: <20080217200947.GH1403@cs181133002.pp.htv.fi> <20080218100126.GA22519@hall.aurel32.net> <20080218100257.GB22519@hall.aurel32.net> <200802181910.46581.mb@bu3sch.de> <47C6C10E.9000300@aurel32.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47C6C10E.9000300@aurel32.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 03:11:26PM +0100, Aurelien Jarno wrote:
> Michael Buesch a écrit :
> > On Monday 18 February 2008 11:02:57 Aurelien Jarno wrote:
> >> Switch the SSB PCI core driver to the new SPROM data structure now that
> >> the old one has been removed.
> >>
> >> Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
> > 
> > Acked-by: Michael Buesch <mb@bu3sch.de>
> > 
> > John, can you please apply this?
> 
> John, any news about this patch?

I'm sorry, I must have missed it.  I have to respin the pull request
I sent to Dave M. yesterday anyway, so I'll include it in that.

Thanks for reminding me!

John
-- 
John W. Linville
linville@tuxdriver.com
