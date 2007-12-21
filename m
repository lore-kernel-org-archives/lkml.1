Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932AbXLUQBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbXLUQBd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 11:01:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbXLUQB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 11:01:26 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:49214 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750763AbXLUQBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 11:01:25 -0500
Date: Fri, 21 Dec 2007 11:01:25 -0500
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, joe@perches.com,
       davem@davemloft.net, apw@shadowen.org, lizf@cn.fujitsu.com,
       akpm@linux-foundation.org, elendil@planet.nl,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, trivial@kernel.org,
       rdunlap@xenotime.net, jschopp@austin.ibm.com
Subject: Re: Trailing periods in kernel messages
Message-ID: <20071221160125.GJ2310@csclub.uwaterloo.ca>
References: <E1J5ecS-0008UX-00@gondolin.me.apana.org.au> <Pine.LNX.4.64.0712211104080.21721@fbirervta.pbzchgretzou.qr> <20071221114103.GA801@gondor.apana.org.au> <Pine.LNX.4.64.0712211254160.21721@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712211254160.21721@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2007 at 12:55:16PM +0100, Jan Engelhardt wrote:
> o_O  I better continue believing it is the subject. Because with
> one extra word at the front, you can make this a "complete sentence":
> 
> 	Please initialize [the] current offset in xfs_file_readdir.

That still looks like an incomplete sentence, although orders are often
given in that form.  Something like these seem more like complete
sentences:

You should initialize the current offset in xfs_file_readdir.
The driver will now initialize the current offset in xfs_file_readdir.

Where you or the driver is the subject.  Then it makes sense.  Of course
one would tend to assume the driver is just giving status reports so it
implicitly is the subject doing the things, even though there is no
actual sentence saying so.

It is more of the driver saying:

this driver is:
initializing the current offset in xfs_file_readdir
doing some other stuff
then doing some different stuff
etc

--
Len Sorensen
