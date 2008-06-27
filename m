Return-Path: <linux-kernel-owner+w=401wt.eu-S1757198AbYF0LNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198AbYF0LNs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 07:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbYF0LNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 07:13:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60691 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754627AbYF0LNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 07:13:37 -0400
Date: Fri, 27 Jun 2008 13:14:15 +0200
From: Bernhard Walle <bwalle@suse.de>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: x86@kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       vgoyal@redhat.com, gregkh@suse.de
Subject: Re: [PATCH 2/2] Use FIRMWARE_MEMMAP on x86/E820
Message-ID: <20080627131415.4d482af2@halley.suse.de>
In-Reply-To: <86802c440806261354y673a5521ie615feafae3b2bd8@mail.gmail.com>
References: <1214511542-28458-1-git-send-email-bwalle@suse.de>
	<1214511542-28458-3-git-send-email-bwalle@suse.de>
	<86802c440806261354y673a5521ie615feafae3b2bd8@mail.gmail.com>
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

* Yinghai Lu [2008-06-26 13:54]:
>
> looks good...
> 
> will produce one patch update early_reserve_e820_mpc_new or
> early_reserve_e820 to update e820_saved too. that contained updated
> mptable for second kernel without acpi support.

You or me? I don't understand ...



Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development
