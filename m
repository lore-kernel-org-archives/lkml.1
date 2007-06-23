Return-Path: <linux-kernel-owner+w=401wt.eu-S1757895AbXFWOYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895AbXFWOYd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 10:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756147AbXFWOYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 10:24:25 -0400
Received: from main.carme.maven.pl ([193.239.45.138]:12462 "EHLO
	main.carme.maven.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169AbXFWOYY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 10:24:24 -0400
From: Arkadiusz Miskiewicz <arekm@maven.pl>
Organization: SelfOrganizing
To: Andi Kleen <ak@suse.de>
Subject: Re: NAK (bashizm in the /bin/sh script): [PATCH v3] doc/oops-tracing: add Code: decode info
Date: Sat, 23 Jun 2007 16:24:06 +0200
User-Agent: PLD Linux KMail/1.9.7
Cc: Oleg Verych <olecom@flower.upol.cz>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
References: <20070621225108.bb69a93d.randy.dunlap@oracle.com> <200706231309.49701.arekm@maven.pl> <200706231517.28085.ak@suse.de>
In-Reply-To: <200706231517.28085.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706231624.07139.arekm@maven.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 of June 2007, Andi Kleen wrote:
> On Saturday 23 June 2007 13:09, Arkadiusz Miskiewicz wrote:
> > On Saturday 23 of June 2007, Andi Kleen wrote:
> > > Here's a nickel. Get yourself a real shell.
> >
> > POSIX compilant shell isn't real shell?
>
> In this case it's not good enough. We're not writing POSIX portable
> software here, but Linux software where /bin/sh is /bin/bash.

Here on my Linux software /bin/sh is pdksh and bash installation is 
*optional*.

Is it so hard to tell truth in first line of shell script, tha it NEEDS 
exactly bash (#!/bin/bash) ?

> -Andi

-- 
Arkadiusz Mi¶kiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
