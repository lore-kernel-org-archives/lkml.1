Return-Path: <linux-kernel-owner+w=401wt.eu-S1757242AbXFOVcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242AbXFOVcn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 17:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbXFOVcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 17:32:36 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59924 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbXFOVcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 17:32:35 -0400
Date: Fri, 15 Jun 2007 22:32:32 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Alexandre Oliva <aoliva@redhat.com>
Cc: Bernd Paysan <bernd.paysan@gmx.de>, Paulo Marques <pmarques@grupopie.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Krzysztof Halasa <khc@pm.waw.pl>, linux-kernel@vger.kernel.org
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070615213232.GZ21478@ftp.linux.org.uk>
References: <466A3EC6.6030706@netone.net.tr> <200706151014.45383.bernd.paysan@gmx.de> <46727CCF.9030905@grupopie.com> <200706151403.57178.bernd.paysan@gmx.de> <20070615144301.GV21478@ftp.linux.org.uk> <or8xal2ia7.fsf@oliva.athome.lsd.ic.unicamp.br> <20070615185208.GX21478@ftp.linux.org.uk> <ord4zxx732.fsf@oliva.athome.lsd.ic.unicamp.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ord4zxx732.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2007 at 06:04:33PM -0300, Alexandre Oliva wrote:
> > No specific case law, but I'd expect serious [eventual] trouble for
> > somebody trying to slap some different license in such case.
> 
> Consider this (to make the freeing-the-lion story short):
> 
>   Jar file with .class files, with a copy of LGPL in the root of the
>   tree.  No other license anywhere to be seen.  Is it safe to assume
>   the whole thing is under the LGPL?

It certainly sounds like a reasonable first assumption; unless you are
aware of couterexamples, you probably would be able at least to prove
that you've acted in good faith if somebody starts to complain.  IANAL,
obviously, so ask FSF lawyers.  Really.  Especially if you are doing that
for a text associated with FSF-LA in any way.  That's what they are for.
