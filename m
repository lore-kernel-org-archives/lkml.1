Return-Path: <linux-kernel-owner+w=401wt.eu-S1764997AbXF1Rwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764997AbXF1Rwp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 13:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761250AbXF1Rwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 13:52:38 -0400
Received: from lsd-gw.ic.unicamp.br ([143.106.7.165]:40969 "EHLO
	boneca.lsd.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759676AbXF1Rwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 13:52:37 -0400
To: linux-kernel@vger.kernel.org
Subject: Re: how about mutual compatibility between Linux's GPLv2 and GPLv3?
References: <20070622013417.GT21478@ftp.linux.org.uk>
	<20070622041949.GA15625@thunk.org>
	<orejk4edfl.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070625132853.GH10008@csclub.uwaterloo.ca>
	<orhcov7qsz.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070626041013.GG24745@delft.aura.cs.cmu.edu>
	<orvedb4433.fsf@oliva.athome.lsd.ic.unicamp.br>
	<ormyyn40o9.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070626162541.GA5464@delft.aura.cs.cmu.edu>
	<or3b0d0zdz.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070628050852.GA16686@delft.aura.cs.cmu.edu>
	<orodj0y38k.fsf@oliva.athome.lsd.ic.unicamp.br>
From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Date: Thu, 28 Jun 2007 14:52:11 -0300
In-Reply-To: <orodj0y38k.fsf@oliva.athome.lsd.ic.unicamp.br> (Alexandre Oliva's message of "Thu\, 28 Jun 2007 03\:58\:35 -0300")
Message-ID: <or4pksx8z8.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 28, 2007, Alexandre Oliva <oliva@lsd.ic.unicamp.br> wrote:

> So, let's narrow the scenario to: tivoized machine downloads binary
> from protected site, refrains from downloading sources that it could
> download, user can still access and copy the binaries, but can't
> obtain the sources because the machine opted not to get them.

> Now, the user can't distribute the binaries, because doing so without
> being able to get the sources to pass them on would be copyright
> infringement.  Would a court see this as a restriction on distribution
> imposed by the distributor?  Or by the copyright holder?

I'm not sure my point was clear (not even to myself), so let me try to
clarify with a slightly different scenario.

Software vendor places Free Software program for sale on a web site.
Customers pay a fee and are granted access to a web page from which
they can download both binaries and sources.  The web page encourages
them to download the sources first, because, one hour after the
download of the binary completes, the password that grants access to
the web page and to the downloadable bits is revoked.

Sloppy customer downloads only the binaries.  Days later, they decide
they want to hire someone else to modify the software for them.  Then
they realize they don't have the sources, and that they declined the
opportunity to have them.  So they can't reasonably modify the
software, or distribute the software for another party to do it for
them.  They got themselves into this situation by declining the source
download.  The software distributor is not imposing a restriction,
it's the copyright holder that is, through the license.



Now, compare this with the case quoted above, in which the computer,
on behalf of the customer, declines the source download.  Clearly the
license stops the user from distributing the software in these
circumstances, and practical matters pretty much stop the user from
modifying the software for any other purpose, but how is this
different from the unquoted case above?  Can one actually claim that
the tivoizing vendor is imposing a further restriction, even though
the restrictions actually stems from a decision made by the user (or
rather by the computer acting on the user's behalf), and from the
copyright holder?  How could this be phrased as a further restriction,
if the license already restricts distribution without source code, and
concedes that not having the source code makes it nearly impossible to
make modifications?

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
