Return-Path: <linux-kernel-owner+w=401wt.eu-S1752906AbYKSRez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbYKSRez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 12:34:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbYKSReq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 12:34:46 -0500
Received: from ns.suse.de ([195.135.220.2]:40117 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203AbYKSReq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 12:34:46 -0500
Date: Wed, 19 Nov 2008 18:34:44 +0100
From: Bernhard Walle <bwalle@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "wim@iguana.be" <wim@iguana.be>,
       "stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH] [WATCHDOG] [hpwdt] Set the mapped BIOS address space as
 executable
Message-ID: <20081119183444.56b342cb@hale.suse.de>
In-Reply-To: <20081119093041.1af8fd7e.akpm@linux-foundation.org>
References: <1226674023-5374-1-git-send-email-bwalle@suse.de>
	<20081118143015.72af31d3.akpm@linux-foundation.org>
	<20081118233229.294270fb@kopernikus.site>
	<183C1D5A376DE343AA8F94FC2A1EC1493AA5CEE7AB@GVW1091EXB.americas.hpqcorp.net>
	<20081119093041.1af8fd7e.akpm@linux-foundation.org>
Organization: SUSE Linux Products GmbH
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
X-Face: ,G!z)dEOMkc[Cu+sF64,T9^5r3b>/}#HBRL%D^j@\SZbr'Itl7q@1<*dgB?A7(_leO1Tc4^
 D*WfvfwKcz;,@E^y+pNP%86n8o<&g-vToCXW:r>Y$jxY,`KT?{H!07=2|Jdt?0ba^C-Tnx50vIV8It
 vi&Sicl:sj`k2`y)E;ECFi;i7W-?t3%\kD*));q)+%-pQd^.r'W}oBBx=+.~Gu}&F;lS7.a-m>Rv"w
 pe`D'OV^?HJd$-)7<2T[naDPl6+bAj'+UYd]u]B^'.LYK$2jS
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton [2008-11-19 09:30]:
> > 
> 
> (top-posting repaired.  Please don't top-post!)
> 
> I haven't seen any patch which alters hpwdt_pretimeout() and there is
> no such patch in linux-next.  Perhaps it got lost?

I need to repost.


Regards,
Bernhard
