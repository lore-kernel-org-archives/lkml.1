Return-Path: <linux-kernel-owner+w=401wt.eu-S1759283AbXFWNcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759283AbXFWNcj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 09:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760948AbXFWN15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 09:27:57 -0400
Received: from 1wt.eu ([62.212.114.60]:3129 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760940AbXFWN14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 09:27:56 -0400
Date: Sat, 23 Jun 2007 15:26:26 +0200
From: Willy Tarreau <w@1wt.eu>
To: Andi Kleen <ak@suse.de>
Cc: Arkadiusz Miskiewicz <arekm@maven.pl>, Oleg Verych <olecom@flower.upol.cz>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: NAK (bashizm in the /bin/sh script): [PATCH v3] doc/oops-tracing: add Code: decode info
Message-ID: <20070623132626.GB32449@1wt.eu>
References: <20070621225108.bb69a93d.randy.dunlap@oracle.com> <200706231300.22197.ak@suse.de> <200706231309.49701.arekm@maven.pl> <200706231517.28085.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706231517.28085.ak@suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2007 at 03:17:27PM +0200, Andi Kleen wrote:
> On Saturday 23 June 2007 13:09, Arkadiusz Miskiewicz wrote:
> > On Saturday 23 of June 2007, Andi Kleen wrote:
> > > Here's a nickel. Get yourself a real shell.
> >
> > POSIX compilant shell isn't real shell?
> 
> In this case it's not good enough. We're not writing POSIX portable software 
> here, but Linux software where /bin/sh is /bin/bash. Similar to the Linux 
> kernel which is not written in portable ISO C.

Well, it can also be zsh or pdksh, but I suspect that the code is valid on
them too.

Willy

