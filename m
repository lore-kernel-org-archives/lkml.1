Return-Path: <linux-kernel-owner+w=401wt.eu-S1752190AbZKLFFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbZKLFFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 00:05:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751748AbZKLFFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 00:05:49 -0500
Received: from smtp.nokia.com ([192.100.122.230]:40678 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbZKLFFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 00:05:48 -0500
Subject: Re: [PATCH 00/19] OMAP: DSS2 v5 intro
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Tony Lindgren <tony@atomide.com>
Cc: Tomi Valkeinen <tomi.valkeinen@nokia.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-fbdev-devel@lists.sourceforge.net" 
	<linux-fbdev-devel@lists.sourceforge.net>
In-Reply-To: <20091111184208.GC24837@atomide.com>
References: <1257767126-12059-1-git-send-email-tomi.valkeinen@nokia.com>
	 <1257856848.21596.753.camel@localhost>
	 <1257929140.20378.51.camel@tubuntu.research.nokia.com>
	 <1257932641.20378.77.camel@tubuntu.research.nokia.com>
	 <20091111184208.GC24837@atomide.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Nov 2009 07:03:42 +0200
Message-Id: <1258002222.21596.1129.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 12 Nov 2009 05:03:48.0260 (UTC) FILETIME=[84AA3E40:01CA6355]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-11 at 10:42 -0800, Tony Lindgren wrote:
> * Tomi Valkeinen <tomi.valkeinen@nokia.com> [091111 01:43]:
> > On Wed, 2009-11-11 at 09:45 +0100, Valkeinen Tomi (Nokia-D/Helsinki)
> > wrote:
> > > On Tue, 2009-11-10 at 13:40 +0100, Artem Bityutskiy wrote:
> > > > Tomi,
> > > > 
> > > > could you please kindly ask Stephen (CCed) to include the DSS2 tree into
> > > > linux-next, because you are going to merge it the next merge window, and
> > > > there does not seem to be any blocker for this.
> > > > 
> > > > Being in linux-next for a while is really important.
> > > 
> > > Stephen, would this be possible? DSS2 driver is rather big piece of
> > > code, even if it's quite isolated, so it would be nice to have it in
> > > linux-next.
> > > 
> > > What does it require from me? A git tree, obviously, but what should it
> > > be based on?
> > 
> > Ah, I just realized that DSS2 patches depend on patches from Tony's
> > tree. I guess I should base my tree on top of some Tony's tree that is
> > going to linux-next?
> 
> Or I can merge them into my for-next if that's OK with everybody. This
> merge cycle is a pain for omap as we've moved all the common headers from
> include/mach to include/plat.

I thought everything stable which you are going to merge next merge
window should be in the next branch by default. Especially these massive
re-names which potentially may break many things, right?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

