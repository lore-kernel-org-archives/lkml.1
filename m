Return-Path: <linux-kernel-owner+w=401wt.eu-S1753466AbXFNUzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466AbXFNUzw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 16:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750861AbXFNUzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 16:55:45 -0400
Received: from bee.hiwaay.net ([216.180.54.11]:36099 "EHLO bee.hiwaay.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbXFNUzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 16:55:44 -0400
Date: Thu, 14 Jun 2007 15:55:41 -0500
From: Chris Adams <cmadams@hiwaay.net>
To: linux-kernel@vger.kernel.org
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070614205541.GA886803@hiwaay.net>
References: <fa.V8u0BBHrkymrjcYrFArgehF4jRA@ifi.uio.no> <fa.98cYXp0MWFizp+AzMAkKWAo+bpE@ifi.uio.no> <fa.21pY11gonruis9l1QAvUgcD/c7g@ifi.uio.no> <fa.dR+SnekmQGzom7HRgnAyn3+gVkU@ifi.uio.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <orr6oefpg4.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Mutt/1.4i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Once upon a time, Alexandre Oliva  <aoliva@redhat.com> said:
>> What the GPL *does* say is that you can't "add additional
>> restrictions to the license"
>
>Not quite.  It's more general than that:
>
>  You may not impose any further restrictions on the recipients'
>  exercise of the rights granted herein.

GPLv2 section 0 says:

  Activities other than copying, distribution and modification are not
  covered by this License; they are outside its scope.  The act of
  running the Program is not restricted, ...

The license does not cover running of the program.  It doesn't restrict
it, but it doesn't cover it.  Claiming otherwise is turning the GPL into
yet another dreaded EULA.

Nowhere does the GPLv2 define modification as "modify and run in place".
The Preamble emphasizes sharing; hardware is a fixed object and can't be
shared in the same fashion as software.

Also, GPLv2 section 2 includes:

  In addition, mere aggregation of another work not based on the Program
  with the Program (or with a work based on the Program) on a volume of
  a storage or distribution medium does not bring the other work under
  the scope of this License.

TiVo's firmware (and any restrictions it may carry) is not affected by
the GPLv2.

