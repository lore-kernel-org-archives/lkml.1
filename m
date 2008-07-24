Return-Path: <linux-kernel-owner+w=401wt.eu-S1753307AbYGXIV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbYGXIV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 04:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751191AbYGXIVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 04:21:16 -0400
Received: from cantor.suse.de ([195.135.220.2]:47920 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040AbYGXIVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 04:21:15 -0400
Date: Thu, 24 Jul 2008 10:21:12 +0200
From: Bernhard Walle <bwalle@suse.de>
To: "jidong xiao" <jidong.xiao@gmail.com>
Cc: "Vivek Goyal" <vgoyal@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Crashkernel memory reservation fails with 2.6.26
Message-ID: <20080724102112.3c15a13f@kopernikus.site>
In-Reply-To: <20080724101916.61dfa086@kopernikus.site>
References: <4104961b0807232012r712bd456n26db52bc946efa9a@mail.gmail.com>
	<20080724101916.61dfa086@kopernikus.site>
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

* Bernhard Walle <bwalle@suse.de> [2008-07-24 10:19]:
>
> * "jidong xiao" <jidong.xiao@gmail.com> [2008-07-24 11:12]:
> >
> > Hi,Bernhard/Vivek,
> > 	I was facing the same issue as raised by Sachin sometime back, see below link:
> > 
> > http://lkml.org/lkml/2008/2/4/193
> > 
> > The difference is I am using kernel 2.6.26 while Sachin was using
> > 2.6.24-rc8-mm1.
> > 
> > I saw you were discussing this issue but is there any result?Any
> > workaround for me?
> 
> Please test http://article.gmane.org/gmane.linux.kernel.kexec/1883.

Which is http://download.gmane.org/gmane.linux.kernel.kexec/1883/1884
as plain text, BTW.


Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development
