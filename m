Return-Path: <linux-kernel-owner+w=401wt.eu-S1752312AbXH0HVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312AbXH0HVo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 03:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751210AbXH0HVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 03:21:35 -0400
Received: from lilly.ping.de ([83.97.42.2]:3240 "HELO lilly.ping.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750832AbXH0HVf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 03:21:35 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Aug 2007 03:21:35 EDT
Date: 27 Aug 2007 09:14:48 +0200
Message-ID: <46D279E8.10001@edge.ping.de>
From: "Tim Teulings" <rael@edge.ping.de>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "=?ISO-8859-1?Q?Rog=E9rio_Brito?=" <rbrito@gmail.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       debian-powerpc@lists.debian.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070622)
MIME-Version: 1.0
Subject: Re: Sleep problems with kernels >= 2.6.21 on powerpc
References: <6540c930708251937o2a9a23efv72a0f2b8947067bd@mail.gmail.com> <6bffcb0e0708261621q25316becqce7b3ae2176f45a8@mail.gmail.com> <20070827065246.GA21220@ime.usp.br>
In-Reply-To: <20070827065246.GA21220@ime.usp.br>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo!

I also have 800MHz iBook (2.2, 2 USB) and had the same problem with the 
21.6.22 kernel a while ago and reverted back to 2.6.21. I'm not a kernel 
guy but I think I remember from kernel traces that it looked like (wise 
chosen words ;-)) that the problems had something to do with 
deactivating the firewire "subsystem".

I don't have traces at hand and due to lack of time cannot reproduce it 
up to tomorrow. However this hint may speed up your analysis!

[rather long To-list, is everybody happy with this?]

-- 
Gruﬂ...
        Tim

