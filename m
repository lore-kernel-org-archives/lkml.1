Return-Path: <linux-kernel-owner+w=401wt.eu-S1757464AbXFOSwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464AbXFOSwW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 14:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753871AbXFOSwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 14:52:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45259 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676AbXFOSwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 14:52:12 -0400
Date: Fri, 15 Jun 2007 19:52:08 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Alexandre Oliva <aoliva@redhat.com>
Cc: Bernd Paysan <bernd.paysan@gmx.de>, Paulo Marques <pmarques@grupopie.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Krzysztof Halasa <khc@pm.waw.pl>, linux-kernel@vger.kernel.org
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070615185208.GX21478@ftp.linux.org.uk>
References: <466A3EC6.6030706@netone.net.tr> <200706151014.45383.bernd.paysan@gmx.de> <46727CCF.9030905@grupopie.com> <200706151403.57178.bernd.paysan@gmx.de> <20070615144301.GV21478@ftp.linux.org.uk> <or8xal2ia7.fsf@oliva.athome.lsd.ic.unicamp.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <or8xal2ia7.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2007 at 03:18:24PM -0300, Alexandre Oliva wrote:
> On Jun 15, 2007, Al Viro <viro@ftp.linux.org.uk> wrote:
> 
> > *OR* inherits the default license of the project.
> 
> You got any case law for this?  Seriously, I could use this for
> FSFLA's IRPF2007-Livre project.
> http://fsfla.org/svnwiki/blogs/lxo/pub/freeing-the-lion

Umm...  What other license choices are there?  Seriously, if file
*does* get a license from somewhere (and if it doesn't, it can't
be distributed at all), where else would that license come from?

I can see one arguing that it shouldn't be distributed at all (and
we obviously don't want that), I can see one arguing that copyright
statement floating in root of tree in file called "COPYING" and
not tied to specific parts of that tree should apply, but I don't
see how one would argue that some other license he happens to like
should apply here.

No specific case law, but I'd expect serious [eventual] trouble for
somebody trying to slap some different license in such case.  Not
sure if anybody actually ever tried that...

IIRC, the usual argument for slapping copyright into every file is
along the lines of "making sure that it doesn't get lost when
file is lifted into another project", not "it's free for grabbing
by anyone" or "it can't be distributed at all"...
