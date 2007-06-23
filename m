Return-Path: <linux-kernel-owner+w=401wt.eu-S1757879AbXFWNS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879AbXFWNS3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 09:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbXFWNSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 09:18:22 -0400
Received: from ns2.suse.de ([195.135.220.15]:54790 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752520AbXFWNSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 09:18:21 -0400
From: Andi Kleen <ak@suse.de>
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Subject: Re: NAK (bashizm in the /bin/sh script): [PATCH v3] doc/oops-tracing: add Code: decode info
Date: Sat, 23 Jun 2007 15:17:27 +0200
User-Agent: KMail/1.9.1
Cc: Oleg Verych <olecom@flower.upol.cz>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
References: <20070621225108.bb69a93d.randy.dunlap@oracle.com> <200706231300.22197.ak@suse.de> <200706231309.49701.arekm@maven.pl>
In-Reply-To: <200706231309.49701.arekm@maven.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706231517.28085.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 June 2007 13:09, Arkadiusz Miskiewicz wrote:
> On Saturday 23 of June 2007, Andi Kleen wrote:
> > Here's a nickel. Get yourself a real shell.
>
> POSIX compilant shell isn't real shell?

In this case it's not good enough. We're not writing POSIX portable software 
here, but Linux software where /bin/sh is /bin/bash. Similar to the Linux 
kernel which is not written in portable ISO C.

-Andi
