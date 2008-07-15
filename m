Return-Path: <linux-kernel-owner+w=401wt.eu-S1756659AbYGOMB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659AbYGOMB4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 08:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755145AbYGOMBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 08:01:49 -0400
Received: from ns1.suse.de ([195.135.220.2]:49904 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754455AbYGOMBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 08:01:48 -0400
Date: Tue, 15 Jul 2008 14:02:29 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: =?UTF-8?B?RnLDqWTDqXJpYw==?= Weisbecker <fweisbec@gmail.com>,
       =?UTF-8?B?VMO2csO2aw==?= Edwin <edwintorok@gmail.com>,
       linux-next@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: today's linux-next fails to boot
Message-ID: <20080715140229.4589e096@halley.suse.de>
In-Reply-To: <s5hprpf4b43.wl%tiwai@suse.de>
References: <4877400B.1000400@gmail.com>
	<487C074E.8080309@gmail.com>
	<s5htzer4d9p.wl%tiwai@suse.de>
	<20080715131553.61f36ca2@halley.suse.de>
	<20080715131744.0e1e20a3@halley.suse.de>
	<s5hprpf4b43.wl%tiwai@suse.de>
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

* Takashi Iwai [2008-07-15 13:53]:
> At Tue, 15 Jul 2008 13:17:44 +0200,
> Bernhard Walle wrote:
> > 
> > * Bernhard Walle [2008-07-15 13:15]:
> > >
> > > * Takashi Iwai [2008-07-15 13:06]:
> > > > 
> > > > Added Bernhard to Cc.  Maybe we should defer firmware_map_add*()?
> > > 
> > > Yes. I already posted a patch for that.
> > > 
> > > http://article.gmane.org/gmane.linux.kernel.kexec/1882
> > 
> > Which does not defer firmware_map_add*() but the kobject
> > initialisation. Which also fixes the problem.
> 
> Thanks, it's good to know that the fix is already pending.

What's the process to get that to linux-next? Ingo's tip tree.



Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development
