Return-Path: <linux-kernel-owner+w=401wt.eu-S1030632AbXFHO2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030632AbXFHO2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 10:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967230AbXFHO2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 10:28:07 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:42465 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968873AbXFHO2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 10:28:06 -0400
Date: Fri, 8 Jun 2007 16:28:49 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Verych <olecom@flower.upol.cz>, kbuild-devel@lists.sourceforge.net,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] scripts: clean-whitespace.sh
Message-ID: <20070608142849.GA23642@uranus.ravnborg.org>
References: <20070605145759.GP7266@flower.upol.cz> <20070605151101.GQ7266@flower.upol.cz> <20070606174556.GS7266@flower.upol.cz> <20070606175026.GA6303@uranus.ravnborg.org> <20070606191426.GT7266@flower.upol.cz> <Pine.LNX.4.64.0706071634470.8762@fbirervta.pbzchgretzou.qr> <20070607230657.GV7266@flower.upol.cz> <4668929C.7040209@zytor.com> <E1HwY9K-0008Jz-CG@flower> <20070607234459.e4dffd65.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070607234459.e4dffd65.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 11:44:59PM -0700, Andrew Morton wrote:
> 
> Then again, it's a better strategy than trying to read the code ;)
> 
> Please, tell us what it does, so that we can decide whether we want it in
> Linux.

It does the same as cleanfile.pl.
I have seen no reason to replace cleanfile.pl with this version.

Linecount is down but so is maintainability / extendability.

	Sam
