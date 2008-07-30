Return-Path: <linux-kernel-owner+w=401wt.eu-S1757545AbYG3HHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545AbYG3HHa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 03:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbYG3HGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 03:06:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:39507 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877AbYG3HGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 03:06:53 -0400
Date: Wed, 30 Jul 2008 09:06:50 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Greg KH <greg@kroah.com>
Cc: Hugh Dickins <hugh@veritas.com>, Greg KH <gregkh@suse.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Dave Hansen <haveblue@us.ibm.com>
Subject: Re: linux-next: Tree for July 29
Message-ID: <20080730090650.79a5a749@kopernikus.site>
In-Reply-To: <20080730044834.GB2954@kroah.com>
References: <20080729172337.b3d74100.sfr@canb.auug.org.au>
	<200807291825.14281.bzolnier@gmail.com>
	<20080729181639.GA21311@suse.de>
	<Pine.LNX.4.64.0807292145220.28604@blonde.site>
	<20080730044834.GB2954@kroah.com>
Organization: SUSE LINUX Products GmbH
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i686-pc-linux-gnu)
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

* Greg KH <greg@kroah.com> [2008-07-29 21:48]:
> > Isn't this the opposite end of the same problem for which Bernhard
> > has been repeatedly trying to find a taker for his patch:
> > 
> > http://article.gmane.org/gmane.linux.kernel.kexec/1882
> 
> Yes.  It's not the kobject patch at fault here, it's the use of kobjects
> so early in the boot process.  That needs to be fixed.

Yes, but if somebody could tell me why nobody takes the patch, I would
be happy. Then I would be able to improve the patch. :)




Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development
