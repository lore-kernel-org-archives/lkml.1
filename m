Return-Path: <linux-kernel-owner+w=401wt.eu-S1758124AbYG1QA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124AbYG1QA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 12:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbYG1QAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 12:00:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38803 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059AbYG1QAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 12:00:20 -0400
Date: Mon, 28 Jul 2008 18:01:02 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Subject: Re: x86: move dma32_reserve_bootmem() after reserve_crashkernel()
Message-ID: <20080728180102.298e8a43@halley.suse.de>
In-Reply-To: <20080728152512.GJ32111@elte.hu>
References: <20080727002559.48cee0d4@kopernikus.site>
	<20080728152512.GJ32111@elte.hu>
Organization: SUSE Linux Products GmbH
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
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

* Ingo Molnar [2008-07-28 17:25]:
>
> 
> * Bernhard Walle <bwalle@suse.de> wrote:
> 
> > Hi Ingo,
> > 
> > can you send 91467bdf6e53058af13fd255375d6634ba0c70e0 (in 
> > x86/crashdump) to Linus still for 2.6.27? I want that also in stable 
> > for 2.6.26, and Greg KH stated that it must be first in Linus' tree.
> 
> ok - i've merged it into x86/urgent.

Thanks.



Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development
