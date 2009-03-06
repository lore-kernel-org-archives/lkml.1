Return-Path: <linux-kernel-owner+w=401wt.eu-S1756391AbZCFTpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391AbZCFTpm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 14:45:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753938AbZCFTpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 14:45:30 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44671 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080AbZCFTp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 14:45:29 -0500
Date: Fri, 6 Mar 2009 14:40:45 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Gabor Juhos <juhosg@openwrt.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: linux-next: Tree for March 6 (ath9k)
Message-ID: <20090306194045.GE3712@tuxdriver.com>
References: <20090306191311.697e7b97.sfr@canb.auug.org.au> <49B17320.8010000@oracle.com> <49B17B12.3050200@openwrt.org> <49B17C4E.3000004@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49B17C4E.3000004@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 11:41:02AM -0800, Randy Dunlap wrote:
> Gabor Juhos wrote:
> > Randy Dunlap írta:
> >> Stephen Rothwell wrote:
> >>> Hi all,
> >>>
> >>> Linus' release of -rc7 seems to have stirred people up a bit ...
> >>>
> >>> Changes since 20090305:
> >>
> >> when CONFIG_RFKILL=n, ath9k/virtual.c causes:
> >>
> >> (.text+0x224e83): undefined reference to `ath_radio_disable'
> >> (.text+0x224e8b): undefined reference to `ath_radio_enable'
> >>
> >>
> > 
> > Hi,
> > 
> > I have submitted a patch for this already:
> > http://marc.info/?l=linux-wireless&m=123633468314970&w=2
> > 
> > Should I send it to somewhere else as well?
> 
> It hasn't propagated into the linux-next merging yet...

He just sent it today (or overnight).  I'll get it into wireless-next.

John

P.S.  I'm starting to think that RFKILL should just be mandatory...
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
