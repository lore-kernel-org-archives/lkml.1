Return-Path: <linux-kernel-owner+w=401wt.eu-S1755623AbYBQCWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623AbYBQCWZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 21:22:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbYBQCWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 21:22:18 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:47059 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbYBQCWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 21:22:17 -0500
X-IronPort-AV: E=Sophos;i="4.25,365,1199682000"; 
   d="scan'208";a="62404374"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Stephen Rothwell" <sfr@canb.auug.org.au>
Subject: Re: linux-next: first tree
Date: Sat, 16 Feb 2008 21:23:47 -0500
User-Agent: KMail/1.9.5
Cc: "Bryan Wu" <cooloney.lkml@gmail.com>, linux-next@vger.kernel.org,
       "LKML" <linux-kernel@vger.kernel.org>
References: <20080215003537.8911ce35.sfr@canb.auug.org.au> <386072610802150033k4dc2faf1je119bf5516336ee9@mail.gmail.com> <20080217023337.e94ceb48.sfr@canb.auug.org.au>
In-Reply-To: <20080217023337.e94ceb48.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802162123.47355.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 17 Feb 2008 02:22:15.0570 (UTC) FILETIME=[E9799F20:01C8710B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 16 Feb 2008 10:33, Stephen Rothwell pondered:
> On Fri, 15 Feb 2008 16:33:50 +0800 "Bryan Wu" <cooloney.lkml@gmail.com> wrote:
> >
> > Could you please add Blackfin tree to the linux-next
> > 
> >  git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.git
> > for-linus
> 
> Added, thanks.
> 
> > And do you have the blackfin cross-compile toolchain?
> 
> No, I don't at the moment.

You can grab (i386 rpms and tar ball) that should work from:

http://blackfin.uclinux.org/gf/project/toolchain/frs/?action=FrsReleaseView&release_id=375

You will need:
 - toolchain blackfin-toolchain-08r1-8.i386.rpm
 - c library (either one of):
    - blackfin-toolchain-uclibc-default-08r1-8.i386.rpm
    - blackfin-toolchain-uclibc-full-08r1-8.i386.rpm

Other arch's & packages should appear shortly.

-Robin
