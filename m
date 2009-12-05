Return-Path: <linux-kernel-owner+w=401wt.eu-S1757603AbZLEC50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603AbZLEC50 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 21:57:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755389AbZLEC5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 21:57:23 -0500
Received: from lixom.net ([66.141.50.11]:37155 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754897AbZLEC5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 21:57:23 -0500
Date: Fri, 4 Dec 2009 20:59:49 -0600
From: Olof Johansson <olof@lixom.net>
To: Joe Perches <joe@perches.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>, Colin Leroy <colin@colino.net>,
       Paul Mackerras <paulus@samba.org>, Jean Delvare <khali@linux-fr.org>,
       "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH] MAINTAINERS: Add PowerPC patterns
Message-ID: <20091205025949.GA29554@lixom.net>
References: <20091202091951.5ec6bb83@hyperion.delvare> <1259894454.2076.1246.camel@pasglop> <20091204103434.0a754925@hyperion.delvare> <1259920775.2076.1273.camel@pasglop> <1259947019.22783.116.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259947019.22783.116.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 04, 2009 at 09:16:59AM -0800, Joe Perches wrote:
> On Fri, 2009-12-04 at 20:59 +1100, Benjamin Herrenschmidt wrote:
> > On Fri, 2009-12-04 at 10:34 +0100, Jean Delvare wrote:
> > > I've sent it to linuxppc-dev@ozlabs.org on October 14th. This is the
> > > address which is listed 22 times in MAINTAINERS. If it isn't correct,
> > > then please update MAINTAINERS.
> > No it's fine both shoul work. Your patches are there, just waiting for
> > me to pick them up, I was just firing a reminder to the rest of the CC
> > list :-) (and I do remember fwd'ing a couple of your patches to the
> > list, for some reason they didn't make it to patchwork back then, that
> > was a few month ago).
> > Anyways, I've been stretched thin with all sort of stuff lately, so bear
> > with me if I'm a bit slow at taking or testing stuff, I'm doing my best.
> 
> Adding patterns to the PowerPC sections of MAINTAINERS is useful.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Olof Johansson <olof@lixom.net>

There are a few other files under arch/powerpc that's not under platforms
that belongs to the pasemi code but it's not a big deal to not include
them. This goes most of the way.


-Olof
