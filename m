Return-Path: <linux-kernel-owner+w=401wt.eu-S1760565AbZAWCG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760565AbZAWCG1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 21:06:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756549AbZAWCFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 21:05:55 -0500
Received: from kroah.org ([198.145.64.141]:33990 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755783AbZAWCFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 21:05:53 -0500
Date: Thu, 22 Jan 2009 18:04:03 -0800
From: Greg KH <greg@kroah.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Greg KH <gregkh@suse.de>, "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "David S. Miller" <davem@davemloft.net>,
       Florian Fainelli <florian@openwrt.org>, torvalds@linux-foundation.org,
       Eugene Teo <eteo@redhat.com>, Justin Forbes <jmforbes@linuxtx.org>,
       linux-kernel@vger.kernel.org, Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>,
       Randy Dunlap <rdunlap@xenotime.net>, Willy Tarreau <w@1wt.eu>,
       Michael Krufky <mkrufky@linuxtv.org>, alan@lxorguk.ukuu.org.uk,
       Chuck Ebbert <cebbert@redhat.com>, Dave Jones <davej@redhat.com>,
       akpm@linux-foundation.org, Jake Edge <jake@lwn.net>,
       Chuck Wolber <chuckw@quantumlinux.com>, stable@kernel.org,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>
Subject: Re: [stable] [patch 24/46] r6040: bump release number to 0.19
Message-ID: <20090123020403.GA4712@kroah.com>
References: <20090123010651.683741823@mini.kroah.org> <20090123011219.GY19756@kroah.com> <alpine.LNX.2.00.0901230225430.12187@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.0901230225430.12187@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2009 at 02:31:22AM +0100, Jesper Juhl wrote:
> On Thu, 22 Jan 2009, Greg KH wrote:
> 
> > 2.6.28-stable review patch.  If anyone has any objections, please let us know.
> > 
> 
> It's simple enough, sure, but it doesn't really conform to the guidelines 
> set out for -stable patches in Documentation/stable_kernel_rules.txt : 
> 
> ...
>  - It must fix a real bug that bothers people (not a, "This could be a
>    problem..." type thing).
> ...
>  - It cannot contain any "trivial" fixes in it (spelling changes,
>    whitespace cleanups, etc).
> ...
> 
> I'm trying to come up with some real problem this fixes and a reason why 
> we want it in -stable, but I cannot...

You missed the patches leading up to this one that updated the driver to
this version number, without changing the number.  This patch is then
valid.

thanks,

greg "context is everything" k-h
