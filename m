Return-Path: <linux-kernel-owner+w=401wt.eu-S1756933AbZGMSaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933AbZGMSaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 14:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756863AbZGMSaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 14:30:25 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:56594 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756825AbZGMSaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 14:30:24 -0400
X-IronPort-AV: E=Sophos;i="4.42,391,1243828800"; 
   d="scan'208";a="1461873"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Stephen Rothwell" <sfr@canb.auug.org.au>
Subject: Re: linux-next: Tree for July 13
Date: Mon, 13 Jul 2009 14:33:47 -0400
User-Agent: KMail/1.9.5
CC: linux-next@vger.kernel.org, "LKML" <linux-kernel@vger.kernel.org>
References: <20090713180524.72f613dc.sfr@canb.auug.org.au>
In-Reply-To: <20090713180524.72f613dc.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200907131433.47766.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 13 Jul 2009 18:30:22.0418 (UTC) FILETIME=[FB6F3B20:01CA03E7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 13 Jul 2009 04:05, Stephen Rothwell pondered:
> Status of my local build tests will be at
> http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
> advice about cross compilers/configs that work, we are always open to add
> more builds.

A working Blackfin gcc port should always be avaliable at:

http://blackfin.uclinux.org/gf/project/toolchain/frs/?action=FrsReleaseBrowse&frs_package_id=127

We normally build up toolchains for *.i386.rpm &  *.i386.tar.bz2. If you need 
anything else let us know.

All the defconfigs in arch/blackfin/configs/ should be maintained, and 
working - if not we can quickly fix them - if you wanted to pick one - 
BF537-STAMP_defconfig would be a good one.

-Robin

