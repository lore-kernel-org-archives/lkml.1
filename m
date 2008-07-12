Return-Path: <linux-kernel-owner+w=401wt.eu-S1755757AbYGLWRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757AbYGLWRr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 18:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbYGLWRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 18:17:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:58706 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482AbYGLWRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 18:17:39 -0400
Date: Sun, 13 Jul 2008 00:17:35 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] firmware: fix memmap printk format warnings
Message-ID: <20080713001735.70a33e9e@kopernikus.site>
In-Reply-To: <20080711125836.59cb0c04.randy.dunlap@oracle.com>
References: <20080711125836.59cb0c04.randy.dunlap@oracle.com>
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

* Randy Dunlap <randy.dunlap@oracle.com> [2008-07-11 12:58]:
>
> From: Randy Dunlap <randy.dunlap@oracle.com>
> cc: Bernhard Walle <bwalle@suse.de>
> 
> Fix firmware/memmap printk format warnings:
> 
> linux-next-20080711/drivers/firmware/memmap.c:156: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'resource_size_t'
> linux-next-20080711/drivers/firmware/memmap.c:161: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'resource_size_t'

Thanks for the patch. I did not include that change in my cleanup sent
to Andrew to not conflict with that patch.


Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development
