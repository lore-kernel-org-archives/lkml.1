Return-Path: <linux-kernel-owner+w=401wt.eu-S1754452AbYFXSiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452AbYFXSiU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 14:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751237AbYFXSiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 14:38:12 -0400
Received: from mail.suse.de ([195.135.220.2]:56090 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbYFXSiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 14:38:11 -0400
Date: Tue, 24 Jun 2008 20:38:07 +0200
From: Bernhard Walle <bwalle@suse.de>
To: akataria@vmware.com
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: merge conflicts with tip/master
Message-ID: <20080624203807.232a414a@kopernikus.site>
In-Reply-To: <1214327937.27577.6.camel@promb-2n-dhcp368.eng.vmware.com>
References: <1214327937.27577.6.camel@promb-2n-dhcp368.eng.vmware.com>
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

* Alok Kataria <akataria@vmware.com> [2008-06-24 10:18]:
>
> While working with tip/master...after following the steps in the readme
> @ http://people.redhat.com/mingo/tip.git/readme.txt
> 
> I usually do any changes and manage them using "quilt". 
> Once the changes are pushed upstream, i do a "quilt pop"
> and generally try a "git pull" to check for any new changes, along with
> the change that was just pushed. 

You might also try guilt [1], which is a mix between st-git and quilt.
Just a hint, it does not solve your problem. :)


Bernhard

[1] http://www.kernel.org/pub/linux/kernel/people/jsipek/guilt/

-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development
