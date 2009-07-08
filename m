Return-Path: <linux-kernel-owner+w=401wt.eu-S1755559AbZGHRgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559AbZGHRgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 13:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754477AbZGHRgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 13:36:08 -0400
Received: from mail.samba.org ([66.70.73.150]:39904 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754125AbZGHRgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 13:36:07 -0400
X-Greylist: delayed 1397 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Jul 2009 13:36:07 EDT
Date: Wed, 8 Jul 2009 10:12:48 -0700
From: Jeremy Allison <jra@samba.org>
To: Jamie Lokier <jamie@shareable.org>
Cc: Martin Steigerwald <Martin@lichtvoll.de>, tridge@samba.org,
       Jan Engelhardt <jengelh@medozas.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org, James.Bottomley@hansenpartnership.com
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
Message-ID: <20090708171248.GC23300@samba1>
Reply-To: Jeremy Allison <jra@samba.org>
References: <19013.8005.541836.436991@samba.org> <200907072356.51553.Martin@lichtvoll.de> <19028.3736.892828.352905@samba.org> <200907081339.59815.Martin@lichtvoll.de> <20090708135327.GA21508@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090708135327.GA21508@shareable.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 08, 2009 at 02:53:27PM +0100, Jamie Lokier wrote:

> Heh.  I still use Windows 95 and Windows 98 occasionally.  I'm a bit
> disappointed to find Samba no longer tests against them :-)

We do run regression tests that emulate Win9x against Samba
and ensure we pass. We also fix bugs reported by Win9x and
OS/2 users with Samba.

Jeremy.
