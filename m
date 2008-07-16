Return-Path: <linux-kernel-owner+w=401wt.eu-S1758446AbYGPNmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758446AbYGPNmj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 09:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756474AbYGPNmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 09:42:31 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1678 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012AbYGPNmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 09:42:31 -0400
Date: Wed, 16 Jul 2008 14:41:47 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: jkacur <jkacur@gmail.com>, akpm@linux-foundation.org,
       Jan Engelhardt <jengelh@medozas.de>, Andy Whitcroft <apw@shadowen.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Make the git URL match usage
Message-ID: <20080716134144.GA28848@sirena.org.uk>
Mail-Followup-To: Adrian Bunk <bunk@kernel.org>, jkacur <jkacur@gmail.com>,
	akpm@linux-foundation.org, Jan Engelhardt <jengelh@medozas.de>,
	Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org
References: <200807161500.08500.jkacur@gmail.com> <20080716133108.GC25557@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080716133108.GC25557@cs181140183.pp.htv.fi>
X-Cookie: Last week's pet, this week's special.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 04:31:08PM +0300, Adrian Bunk wrote:
> On Wed, Jul 16, 2008 at 03:00:08PM +0200, jkacur wrote:

> > grep git:// MAINTAINERS | grep -v "\.git"

...

> > T:      git://opensource.wolfsonmicro.com/linux-2.6-asoc
> > T:      git://opensource.wolfsonmicro.com/linux-2.6-touch
> >...

> With the default git-daemon configuration it doesn't matter whether or 
> not you specify a .git postfix.

For those two HTTP access currently requires that the .git be omitted.
I could change that easily enough but TBH I prefer giving the link with
the directory name that a clone would create anyway.
