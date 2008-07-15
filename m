Return-Path: <linux-kernel-owner+w=401wt.eu-S1756397AbYGOLP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397AbYGOLP0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 07:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754122AbYGOLPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 07:15:14 -0400
Received: from ns.suse.de ([195.135.220.2]:45001 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822AbYGOLPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 07:15:13 -0400
Date: Tue, 15 Jul 2008 13:15:53 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: =?UTF-8?B?RnLDqWTDqXJpYw==?= Weisbecker <fweisbec@gmail.com>,
       =?UTF-8?B?VMO2csO2aw==?= Edwin <edwintorok@gmail.com>,
       linux-next@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: today's linux-next fails to boot
Message-ID: <20080715131553.61f36ca2@halley.suse.de>
In-Reply-To: <s5htzer4d9p.wl%tiwai@suse.de>
References: <4877400B.1000400@gmail.com>
	<487C074E.8080309@gmail.com>
	<s5htzer4d9p.wl%tiwai@suse.de>
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

* Takashi Iwai [2008-07-15 13:06]:
> 
> Added Bernhard to Cc.  Maybe we should defer firmware_map_add*()?

Yes. I already posted a patch for that.

http://article.gmane.org/gmane.linux.kernel.kexec/1882



Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development
