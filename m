Return-Path: <linux-kernel-owner+w=401wt.eu-S1756947AbYFZRvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947AbYFZRvP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 13:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbYFZRu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 13:50:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60147 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513AbYFZRu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 13:50:57 -0400
Date: Thu, 26 Jun 2008 19:02:09 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Josh Boyer <jwboyer@gmail.com>
Cc: linuxppc-dev@ozlabs.org, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, vgoyal@redhat.com
Subject: Re: [PATCH] Remove experimental status of kdump on PPC64
Message-ID: <20080626190209.3e046ea8@kopernikus.site>
In-Reply-To: <1214494132.2791.0.camel@weaponx>
References: <1214485035-26041-1-git-send-email-bwalle@suse.de>
	<1214494132.2791.0.camel@weaponx>
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

* Josh Boyer <jwboyer@gmail.com> [2008-06-26 11:28]:
>
> On Thu, 2008-06-26 at 14:57 +0200, Bernhard Walle wrote:
> > This patch removes the experimental status of kdump on IA64. kdump is on IA64
> > now since more than one year and it has proven to be stable.
> 
> I think you mean PPC64?

Right. Copy & paste, I made the same patch for IA64. Resent. Sorry. :)


Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development
