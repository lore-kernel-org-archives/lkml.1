Return-Path: <linux-kernel-owner+w=401wt.eu-S1756095AbYFZHYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095AbYFZHYb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 03:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752874AbYFZHYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 03:24:20 -0400
Received: from mx1.suse.de ([195.135.220.2]:47236 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752550AbYFZHYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 03:24:19 -0400
Date: Thu, 26 Jun 2008 09:24:57 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Bernhard Walle <bwalle@suse.de>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, vgoyal@redhat.com,
       kexec@lists.infradead.org
Subject: Re: [PATCH] Remove CONFIG_EXPERIMENTAL from kdump
Message-ID: <20080626092457.50c58bc2@halley.suse.de>
In-Reply-To: <1214465001-12338-1-git-send-email-bwalle@suse.de>
References: <20080625221635.GD32344@redhat.com>
	<1214465001-12338-1-git-send-email-bwalle@suse.de>
Organization: SUSE Linux Products GmbH
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
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

* Bernhard Walle [2008-06-26 09:23]:
>
> I would suggest to remove the "experimental" status from Kdump.
> Kdump is now in the kernel since a long time and used by Enterprise
> distributions. I don't think that "experimental" is true any more.
> 
> 
> Signed-off-by: Bernhard Walle <bwalle@suse.de>

Sorry, forgot the Acked-by which was the intention to resend it to
Andrew. :-| Sent again.


Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development
