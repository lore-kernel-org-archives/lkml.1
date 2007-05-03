Return-Path: <linux-kernel-owner+w=401wt.eu-S1030914AbXECKp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030914AbXECKp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 06:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030942AbXECKp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 06:45:29 -0400
Received: from opal.biophys.uni-duesseldorf.de ([134.99.176.7]:59524 "EHLO
	opal.biophys.uni-duesseldorf.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030914AbXECKp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 06:45:28 -0400
X-Greylist: delayed 663 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 May 2007 06:45:26 EDT
Date: Thu, 3 May 2007 12:33:42 +0200 (CEST)
From: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>
To: James Simmons <jsimmons@infradead.org>
cc: "Antonino A. Daplas" <adaplas@gmail.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, Michael Schmitz <schmitz@debian.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [patch 05/33] m68k: Atari fb revival
In-Reply-To: <Pine.LNX.4.64.0705022100030.6403@pentafluge.infradead.org>
Message-ID: <Pine.LNX.4.58.0705031229480.8342@xplor.biophys.uni-duesseldorf.de>
References: <20070501203234.252205858@mail.of.borg>  <20070501203330.469191361@mail.of.borg>
 <1178056237.4606.19.camel@daplas> <Pine.LNX.4.64.0705022100030.6403@pentafluge.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Update the atari fb to 2.6 by Michael Schmitz,
> >
> > Finally :-). That leaves only pm3fb that needs porting.
> >
> > It still contains remnants of 2.4 code though, ie, FBCON_HAS_*, but
> > that's minor.
>
> Yeah!!! Its a good step forward. Needs more cleanup down the road.

You bet. I'll kill the old cruft when I get to the pixmap support. My
keyboard and SCSI patches got trashed badly, so I'll need to work on those
first.

	Michael
