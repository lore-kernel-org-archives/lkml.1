Return-Path: <linux-kernel-owner+w=401wt.eu-S1753412AbYKNPw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412AbYKNPw2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 10:52:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbYKNPwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 10:52:21 -0500
Received: from swm.pp.se ([212.247.200.143]:51922 "EHLO uplift.swm.pp.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbYKNPwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 10:52:20 -0500
Date: Fri, 14 Nov 2008 16:52:19 +0100 (CET)
From: Mikael Abrahamsson <swmike@swm.pp.se>
To: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>, Andres Freund <andres@anarazel.de>
Subject: Re: Current suspend issues on Lenovo X200
In-Reply-To: <20081114151522.GD4877@denkbrett.schottelius.org>
Message-ID: <alpine.DEB.1.10.0811141642120.10993@uplift.swm.pp.se>
References: <20081023204326.GB4175@denkbrett.schottelius.org> <200810241123.17883.jbarnes@virtuousgeek.org> <20081025145329.GB4273@denkbrett.schottelius.org> <200811121024.44502.jbarnes@virtuousgeek.org> <20081114151522.GD4877@denkbrett.schottelius.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
Organization: People's Front Against WWW
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2008, Nico -telmich- Schottelius wrote:

> Yep, sorry, opened a new thread. Issue got better (console works without 
> s3_bios), but xorg still reboots the system. I'll try the referenced 
> workaround at 
> http://ubuntuforums.org/showpost.php?p=6105510&postcount=12

This workaround has worked 99% for me since I started using it over a 
week ago (once has it happened that I just got the "black X11 and pointer" 
which required me to power cycle to fix).

Only issue has been that approximately 1 out of 20 wakeups, my wifi won't 
come on after wakeup (LED doesn't even come on). If I sleep it and then 
wake it up again, it's worked properly.

I'm using the Ubuntu 8.10 latest kernel 2.7.27-7-generic.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
