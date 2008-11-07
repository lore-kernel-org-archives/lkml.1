Return-Path: <linux-kernel-owner+w=401wt.eu-S1754119AbYKGJZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbYKGJZq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 04:25:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751434AbYKGJZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 04:25:25 -0500
Received: from canardo.mork.no ([148.122.252.1]:49057 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374AbYKGJZX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 04:25:23 -0500
X-Greylist: delayed 765 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Nov 2008 04:25:22 EST
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Ilpo =?utf-8?Q?J=C3=A4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       David Miller <davem@davemloft.net>, daniel.blueman@gmail.com,
       LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       linux-net@vger.kernel.org
Subject: Re: time for TCP ECN defaulting to on?
Organization: m
References: <6278d2220811040632u7a36d68ekad5de517fd0671bb@mail.gmail.com>
	<alpine.DEB.1.10.0811052316210.10993@uplift.swm.pp.se>
	<20081105.151015.206163697.davem@davemloft.net>
	<alpine.DEB.1.10.0811070529550.10993@uplift.swm.pp.se>
	<Pine.LNX.4.64.0811070931190.23284@wrl-59.cs.helsinki.fi>
	<alpine.DEB.1.10.0811070854361.10993@uplift.swm.pp.se>
X-Hashcash: 1:26:081107:netdev@vger.kernel.org::ZNTdiFVtKxS2+f08:000000000000000000000000000000000000000O4ik
X-Hashcash: 1:26:081107:ilpo.jarvinen@helsinki.fi::MEJrJUIt2/3xMYtM:000000000000000000000000000000000000fsor
X-Hashcash: 1:26:081107:linux-net@vger.kernel.org::9pEr1rLny1bp0rLl:0000000000000000000000000000000000019bCK
X-Hashcash: 1:26:081107:swmike@swm.pp.se::lHtKhc/tfU79ayip:1mVyJ
X-Hashcash: 1:26:081107:daniel.blueman@gmail.com::jVFTWq4Ipbwp2Xcg:0000000000000000000000000000000000003+qzA
X-Hashcash: 1:26:081107:davem@davemloft.net::/ZOKq3vxDDxcx50k:000000000000000000000000000000000000000004ztKq
X-Hashcash: 1:26:081107:linux-kernel@vger.kernel.org::Vf0PzyO9kwKTsVqa:00000000000000000000000000000000BQREf
Date: Fri, 07 Nov 2008 10:12:20 +0100
In-Reply-To: <alpine.DEB.1.10.0811070854361.10993@uplift.swm.pp.se> (Mikael
	Abrahamsson's message of "Fri, 7 Nov 2008 09:11:48 +0100 (CET)")
Message-ID: <8763mzx5l7.fsf@obelix.mork.no>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Abrahamsson <swmike@swm.pp.se> writes:

> I have sent an email (which will hopefully initiate a discussion) to a
> mailinglist populated by a lot of the operational ISP community and
> asked around about ECN and views on that. I also checked around on
> core router platforms (Cisco 12000 and Cisco CRS-1, which definitely
> is two of the top three core router platforms deployed in the world)
> and it seems they do not support ECN as far as I can discern.

I believe you can forget about ECN in core networks as long as these
searches fail:

 http://www.google.com/search?q=%22rfc+5129%22+site%3Acisco.com
 http://www.google.com/search?q=%22rfc+5129%22+site%3Ajuniper.net



Bjørn
