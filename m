Return-Path: <linux-kernel-owner+w=401wt.eu-S1755997AbXFIF6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbXFIF6R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 01:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbXFIF6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 01:58:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:42749 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726AbXFIF6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 01:58:09 -0400
From: Neil Brown <neilb@suse.de>
To: Tarkan Erimer <tarkan@netone.net.tr>
Date: Sat, 9 Jun 2007 15:57:55 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18026.16739.228277.938421@notabene.brown>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: message from Tarkan Erimer on Saturday June 9
References: <466A3EC6.6030706@netone.net.tr>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday June 9, tarkan@netone.net.tr wrote:
> Hi,
> 
> As we know the forthcoming GPL V3 will be not compatible with the GPL V2 
> and Linux Kernel is GPL V2 only.
> So, another point is, which is previously mentioned by Linus and others, 
> that if it is decided to upgrade the Linux Kernel's License to GPL V3, 
> it is needed the permission of all the maintainers permission who 
> contributed to the Linux Kernel and there are a lot of lost or dead 
> maintainers. Which makes it impossible to get all the maintainers' 
> permission.

You don't need the permission of maintainers.  You need the permission
of copyright owners.  The two groups overlap, but are not the same.
Dead people cannot own anything, even copyright.  Their estate
probably can.  I don't think it is theoretically impossible to get
everyone's permission, though it may be quite close to practically
impossible. 

> But; if the Linux kernel should Dual-Licensed (GPL V2 and GPL V3), it 
> will allow us the both worlds' fruits like code exchanging from other 
> Open Source Projects (OpenSolaris etc.) that is compatible with GPL V3 
> and not with GPL V2 and of course the opposite is applicable,too.
> 
> So;at this situation, what is possibility to make the Linux Kernel 
> Dual-Licensed as I mentioned above and what is your opinions and 
> suggestions about this idea ?

Dual licensing is no easier.  It means it is licensed to be used under
either license.  You already have permission to use it under GPLv2.
So to get a dual license, you precisely need to get access under GPLv3
i.e. to convince copyright owners to make that license grant.  A thing
that we have already agreed is at least "hard".

NeilBrown
