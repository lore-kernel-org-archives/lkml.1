Return-Path: <linux-kernel-owner+w=401wt.eu-S1759171AbZAWH44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759171AbZAWH44 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 02:56:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbZAWH4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 02:56:47 -0500
Received: from 1wt.eu ([62.212.114.60]:1722 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572AbZAWH4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 02:56:47 -0500
Date: Fri, 23 Jan 2009 08:53:34 +0100
From: Willy Tarreau <w@1wt.eu>
To: Greg KH <greg@kroah.com>
Cc: Jesper Juhl <jj@chaosbits.net>, Greg KH <gregkh@suse.de>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "David S. Miller" <davem@davemloft.net>,
       Florian Fainelli <florian@openwrt.org>, torvalds@linux-foundation.org,
       Eugene Teo <eteo@redhat.com>, Justin Forbes <jmforbes@linuxtx.org>,
       linux-kernel@vger.kernel.org, Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, alan@lxorguk.ukuu.org.uk,
       Chuck Ebbert <cebbert@redhat.com>, Dave Jones <davej@redhat.com>,
       akpm@linux-foundation.org, Jake Edge <jake@lwn.net>,
       Chuck Wolber <chuckw@quantumlinux.com>, stable@kernel.org,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>
Subject: Re: [stable] [patch 24/46] r6040: bump release number to 0.19
Message-ID: <20090123075334.GA1415@1wt.eu>
References: <20090123010651.683741823@mini.kroah.org> <20090123011219.GY19756@kroah.com> <alpine.LNX.2.00.0901230225430.12187@swampdragon.chaosbits.net> <20090123020403.GA4712@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090123020403.GA4712@kroah.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 06:04:03PM -0800, Greg KH wrote:
> On Fri, Jan 23, 2009 at 02:31:22AM +0100, Jesper Juhl wrote:
> > On Thu, 22 Jan 2009, Greg KH wrote:
> > 
> > > 2.6.28-stable review patch.  If anyone has any objections, please let us know.
> > > 
> > 
> > It's simple enough, sure, but it doesn't really conform to the guidelines 
> > set out for -stable patches in Documentation/stable_kernel_rules.txt : 
> > 
> > ...
> >  - It must fix a real bug that bothers people (not a, "This could be a
> >    problem..." type thing).
> > ...
> >  - It cannot contain any "trivial" fixes in it (spelling changes,
> >    whitespace cleanups, etc).
> > ...
> > 
> > I'm trying to come up with some real problem this fixes and a reason why 
> > we want it in -stable, but I cannot...
> 
> You missed the patches leading up to this one that updated the driver to
> this version number, without changing the number.  This patch is then
> valid.

I too find it important for bug reports that version numbers reflect the
driver status as close as possible.

Willy

