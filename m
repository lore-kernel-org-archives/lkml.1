Return-Path: <linux-kernel-owner+w=401wt.eu-S1763345AbYF0SeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763345AbYF0SeV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 14:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756388AbYF0SeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 14:34:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34247 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755891AbYF0SeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 14:34:14 -0400
Date: Fri, 27 Jun 2008 20:34:09 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Greg KH <gregkh@suse.de>
Cc: x86@kernel.org, kexec@lists.infradead.org, yhlu.kernel@gmail.com,
       vgoyal@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: x86: Add /sys/firmware/memmap
Message-ID: <20080627203409.3bc891e3@kopernikus.site>
In-Reply-To: <20080627181833.GA7735@suse.de>
References: <1214565175-21512-1-git-send-email-bwalle@suse.de>
	<20080627181833.GA7735@suse.de>
Organization: SUSE LINUX Products GmbH
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; i686-pc-linux-gnu)
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

* Greg KH <gregkh@suse.de> [2008-06-27 11:18]:
> 
> Looks good, want me to take this through my tree (due to the firmware
> core change)?  If so, can you get an ack on the x86 portion from the
> respective people as well?

Well, the x86 part only applies on tip (because your tree doesn't have
the e820_{32,64} -> e820 merge). So, wouldn't it easier to ack that
patch from your side and merge via tip?



Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development
