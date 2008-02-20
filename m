Return-Path: <linux-kernel-owner+w=401wt.eu-S933097AbYBTU5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933097AbYBTU5l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:57:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbYBTU52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:57:28 -0500
Received: from blueoakdb.com ([206.248.171.20]:1658 "EHLO
	sheldon.hillsandlakes.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752638AbYBTU50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:57:26 -0500
X-Greylist: delayed 1456 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Feb 2008 15:57:26 EST
From: Pablo Sanchez <pablo@blueoakdb.com>
Reply-To: Pablo Sanchez <pablo@blueoakdb.com>
Organization: Blueoak Database Engineering, Inc
To: suspend-devel@lists.sourceforge.net
Subject: Re: [Suspend-devel] 2.6.25-rc2 System no longer powers off after suspend-to-disk. Screen becomes green.
Date: Wed, 20 Feb 2008 15:33:06 -0500
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jeff Chua <jeff.chua.linux@gmail.com>, Dave Airlie <airlied@linux.ie>,
       Greg KH <gregkh@suse.de>, lkml <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Jesse Barnes <jesse.barnes@intel.com>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802202114.43007.rjw@sisk.pl> <alpine.LFD.1.00.0802201224380.7833@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802201224380.7833@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802201533.06647.pablo@blueoakdb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 February 2008 at 3:29 pm, Linus Torvalds penned
about "Re: [Suspend-devel] 2.6.25-rc2 System no longer powers off after suspend-to-disk. Screen becomes green."

> Can we please get this fixed some day? 

I can't say I even come close to understand what's going on but
getting s2ram to work on my Dell M4300 has been a nightmare.  Even
after writing up how to get it to work (posted on the suspend-devel
list - but no one answered .. yet again), I'm having some quirks.

If I had a bizillion $'s, I'd buy an M4300 for Linus and give him a
million to get it to s2ram!  :p

Cheers,
-- 
Pablo Sanchez - Blueoak Database Engineering, Inc
Ph:    819.459.1926          Toll free:  888.459.1926
Fax:   603.720.7723 (US)     Text Page:  pablo_p@blueoakdb.com

