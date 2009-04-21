Return-Path: <linux-kernel-owner+w=401wt.eu-S1751370AbZDUFUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370AbZDUFUk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 01:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076AbZDUFUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 01:20:30 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:56788 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbZDUFU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 01:20:29 -0400
Date: Tue, 21 Apr 2009 15:17:51 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Paul Mackerras <paulus@samba.org>
Cc: Andrew Morton <akpm@osdl.org>, monstr@monstr.eu,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Linus Torvalds <torvalds@osdl.org>, Michal Simek <monstr@seznam.cz>
Subject: Re: Move dtc and libfdt sources from arch/powerpc/boot to
	scripts/dtc
Message-ID: <20090421051751.GA23934@yookeroo.seuss>
Mail-Followup-To: Paul Mackerras <paulus@samba.org>,
	Andrew Morton <akpm@osdl.org>, monstr@monstr.eu,
	linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
	Linus Torvalds <torvalds@osdl.org>, Michal Simek <monstr@seznam.cz>
References: <18906.57833.843101.770634@drongo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18906.57833.843101.770634@drongo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 07, 2009 at 03:17:29PM +1000, Paul Mackerras wrote:
> David Gibson writes:
> 
> > The vast bulk of this patch is a literal move, the rest is adjusting
> > the various Makefiles to use dtc and libfdt correctly from their new
> > locations.
> 
> Did you test this with a separate object directory?  I get:

Ugh.  Obviously not.  New patch coming.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
