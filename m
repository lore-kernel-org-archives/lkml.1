Return-Path: <linux-kernel-owner+w=401wt.eu-S1754774AbYJUS4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbYJUS4M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 14:56:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbYJUSz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 14:55:57 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:54266 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbYJUSz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 14:55:57 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <48FE2582.7090507@s5r6.in-berlin.de>
Date: Tue, 21 Oct 2008 20:54:58 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080722 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Alex Howells <alex@bytemark.co.uk>
CC: Alexandre Oliva <oliva@lsd.ic.unicamp.br>,
       "H. Peter Anvin" <hpa@kernel.org>, Greg KH <greg@kroah.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
References: <20081016002509.GA25868@kroah.com>	<20081016124943.GE23630@cs181140183.pp.htv.fi>	<20081016151748.GA31075@kroah.com>	<20081016153053.GJ5834@nostromo.devel.redhat.com>	<20081016154726.GA6331@kroah.com>	<20081016171626.GB22554@cs181140183.pp.htv.fi>	<20081017040239.GB28188@kroah.com>	<20081017103138.1ca68d17@lxorguk.ukuu.org.uk>	<48F8C000.8030003@kernel.org> <20081017174226.GF2221@kroah.com>	<48F98DE2.8030205@kernel.org> <ortzb89bak.fsf@oliva.athome.lsd.ic.unicamp.br> <48FCD421.2010208@bytemark.co.uk>
In-Reply-To: <48FCD421.2010208@bytemark.co.uk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Howells wrote:
> What I'd love to see any changes integrate would be a simple way to spot 
> -stable releases in the version number (ie: 2.6.16, 2.6.27, those 
> maintained for a "long" time and hopefully by 2.6.16.50+ quite 'bug 
> free') versus the rest of releases sent out on a more regular basis.

Side note:  Long-term maintained kernels like Adrian's 2.6.16.y or 
distro kernels of this sort -> are not 'quite bug free' <-.  They are 
only -> quite regression free <-.

If you want bug fixes, you generally want new kernels.  Only a fraction 
of the bug fixes in new kernels are backported to the long-term 
maintained stable kernels.  OTOH, also only a fraction of the 
regressions in new kernels is backported to them.
-- 
Stefan Richter
-=====-==--- =-=- =-=-=
http://arcgraph.de/sr/
