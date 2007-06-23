Return-Path: <linux-kernel-owner+w=401wt.eu-S1757879AbXFWNqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879AbXFWNqz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 09:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754295AbXFWNqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 09:46:48 -0400
Received: from mail.gmx.net ([213.165.64.20]:43670 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753937AbXFWNqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 09:46:47 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX1/SrTprqHjSmRKW0AdpJzdi7K+WrbIVS2ez1U05+Q
	IbtjQGvkpbDK1B
Date: Sat, 23 Jun 2007 15:47:10 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Andi Kleen <ak@suse.de>
Cc: Arkadiusz Miskiewicz <arekm@maven.pl>, Oleg Verych <olecom@flower.upol.cz>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: NAK (bashizm in the /bin/sh script): [PATCH v3] doc/oops-tracing: add Code: decode info
Message-ID: <20070623134710.GA31169@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Andi Kleen <ak@suse.de>, Arkadiusz Miskiewicz <arekm@maven.pl>,
	Oleg Verych <olecom@flower.upol.cz>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	lkml <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
References: <20070621225108.bb69a93d.randy.dunlap@oracle.com> <200706231300.22197.ak@suse.de> <200706231309.49701.arekm@maven.pl> <200706231517.28085.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200706231517.28085.ak@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.06.23 15:17:27 +0200, Andi Kleen wrote:
> On Saturday 23 June 2007 13:09, Arkadiusz Miskiewicz wrote:
> > On Saturday 23 of June 2007, Andi Kleen wrote:
> > > Here's a nickel. Get yourself a real shell.
> >
> > POSIX compilant shell isn't real shell?
> 
> In this case it's not good enough. We're not writing POSIX portable software 
> here, but Linux software where /bin/sh is /bin/bash. Similar to the Linux 
> kernel which is not written in portable ISO C.

At least LSB 3.1 doesn't require /bin/sh to be /bin/bash. And if you
want bash, what's the problem with just writing #!/bin/bash instead of
#!/bin/sh?


Björn
