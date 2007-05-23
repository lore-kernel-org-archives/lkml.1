Return-Path: <linux-kernel-owner+w=401wt.eu-S934895AbXEWPP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934895AbXEWPP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 11:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758993AbXEWPPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 11:15:47 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:33971
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755634AbXEWPPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 11:15:46 -0400
From: Rob Landley <rob@landley.net>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] Re: Cleaning up the Documentation directory.
Date: Wed, 23 May 2007 11:15:36 -0400
User-Agent: KMail/1.9.1
Cc: Roland Dreier <rdreier@cisco.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <200705222225.39949.rob@landley.net> <200705230025.45007.rob@landley.net> <Pine.LNX.4.64.0705230922580.19474@anakin>
In-Reply-To: <Pine.LNX.4.64.0705230922580.19474@anakin>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705231115.36845.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 May 2007 3:24 am, Geert Uytterhoeven wrote:
> On Wed, 23 May 2007, Rob Landley wrote:
> > On Tuesday 22 May 2007 10:38 pm, Roland Dreier wrote:
> > >  > I could send a patch to do this, but moving files via patch is icky.  
> > Would it 
> > >  > be better to start a git tree and ask people to pull from it, or to 
send 
> > in 
> > >  > script snippets like the above?
> > > 
> > > Actually a git patch would express that very nicely -- just pass -M to
> > > git-format-patch and it should do the right thing.
> > 
> > Ok.
> > 
> > Signed-off-by: Rob Landley <rob@landley.net>
> > 
> > Move architecture documentation into "arch" and move multiport serio IO 
cards 
> > into serial.
> > 
> > --
> > 
> > Equivalent to:
> >    cd Documentation
> >    mkdir -p arch/amiga
> >    mv zorro.txt arch/amiga
> 
> Amiga part Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
> 
> Probably you want to move Documentation/m68k/README.buddha there, too,
> as it applies to Amiga (both m68k and PPC).

I'll add that to the next batch.  Thanks.

Rob
