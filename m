Return-Path: <linux-kernel-owner+w=401wt.eu-S1760107AbXFWOmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760107AbXFWOmt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 10:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756800AbXFWOmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 10:42:42 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44442 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755521AbXFWOml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 10:42:41 -0400
Date: Sat, 23 Jun 2007 15:48:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <ak@suse.de>
Cc: Arkadiusz Miskiewicz <arekm@maven.pl>, Oleg Verych <olecom@flower.upol.cz>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: NAK (bashizm in the /bin/sh script): [PATCH v3]
 doc/oops-tracing: add Code: decode info
Message-ID: <20070623154803.3c621705@the-village.bc.nu>
In-Reply-To: <200706231634.42907.ak@suse.de>
References: <20070621225108.bb69a93d.randy.dunlap@oracle.com>
	<200706231517.28085.ak@suse.de>
	<20070623153239.78ee86fe@the-village.bc.nu>
	<200706231634.42907.ak@suse.de>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jun 2007 16:34:42 +0200
Andi Kleen <ak@suse.de> wrote:

> On Saturday 23 June 2007 16:32:39 Alan Cox wrote:
>  
> > Having the scripts work with other shells is very helpful for porting,
> > cross building and the like.
> 
> Well then for the majority of cross compile users you should consequently write 
> them in Windows batch language.

That isn't portable or standardised. And there are posix shells for
Windows if you really want to cross build on Windows (and some folks do
for embedded because of debug/ice enviroments - pity them)

> > Also on Linux /bin/sh is not 
> > neccessarily /bin/bash.
> 
> If it's not I think these few distributions give Linux a bad name 
> because they introduce quite unnecessary incompatibilities.
> Hopefully they are not widely used.

On the contrary, it is you who is causing incompatibilities by objecting
to the use of standards compliant behaviour. This is the world according
to the standards not the world according to Andi Kleen. (Which one would
run better is a different debate to which one we live in ;))
