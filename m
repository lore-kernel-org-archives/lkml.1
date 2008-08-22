Return-Path: <linux-kernel-owner+w=401wt.eu-S1755019AbYHVFoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019AbYHVFoI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 01:44:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbYHVFn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 01:43:56 -0400
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:51725
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752253AbYHVFnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 01:43:55 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnwBAEzurUjLrQwS/2dsb2JhbAAItkGBaA
X-IronPort-AV: E=Sophos;i="4.32,249,1217779200"; 
   d="scan'208";a="305073632"
Subject: Re: Compiling the kernel with VMware
From: Ben Nizette <bn@niasdigital.com>
To: Alex Zajac <zajac.attack@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <11887b820808212102y65e4b744q2da69dc3a9d03a30@mail.gmail.com>
References: <11887b820808212026v52c7c7adj175a774e5506f237@mail.gmail.com>
	 <11887b820808212102y65e4b744q2da69dc3a9d03a30@mail.gmail.com>
Content-Type: text/plain
Organization: Nias Digital
Date: Fri, 22 Aug 2008 15:43:51 +1000
Message-Id: <1219383831.4021.247.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-08-21 at 23:02 -0500, Alex Zajac wrote:
> Hello,
> Currently, I wanted to begin work on the kernel, and as such, I need a
> way to compile it. All I have available to me is my XP Home computer
> (and I lack funds to buy another, so please do not just say, "get a
> Linux comp"). The specs are as follows:
> 1.4 Ghz Single-core processor
> 384 MB RAM
> 20 GB hard drive (5.5 GB free right now)
> 
> Now, is there a way to compile the kernel using VMware Player? If so,
> what image would be the best to boot and use? Also, exactly what would
> I have to do to set up VMware and the image so that I could compile?
> 

Probably not the right place for this kind of question..

But yes it can be done, get VMWare player, pick a distribution (any will
work, see, eg, distrowatch for comparisons) then follow distro-specific
instructions around the web.  Note that being able to compile a C
program is enough to be able to compile the kernel (roughly).

	--Ben.
