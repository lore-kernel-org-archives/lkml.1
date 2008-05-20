Return-Path: <linux-kernel-owner+w=401wt.eu-S1762984AbYETU0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762984AbYETU0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 16:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758367AbYETU0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 16:26:46 -0400
Received: from mailout05.t-online.de ([194.25.134.82]:39103 "EHLO
	mailout05.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757624AbYETU0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 16:26:45 -0400
Message-ID: <483333E8.1090200@t-online.de>
Date: Tue, 20 May 2008 22:26:16 +0200
From: Harald Dunkel <harald.dunkel@t-online.de>
User-Agent: Thunderbird 2.0.0.14 (X11/20080503)
MIME-Version: 1.0
To: david@lang.hm
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25.3: su gets stuck for root
References: <4829326A.6060808@t-online.de> <19f34abd0805122347x4d9c5d03m16679d724189790e@mail.gmail.com> <4829D345.7020909@t-online.de> <19f34abd0805140034j75d97ecbw5a03c200645768cb@mail.gmail.com> <482B1BD2.8040400@t-online.de> <19f34abd0805141017g26c13e96t2e7edc23bec263d0@mail.gmail.com> <20080514183558.40178fe5@core> <48306DCA.9070108@t-online.de> <20080518185104.0a539f25@core> <48331FFF.5070300@t-online.de> <alpine.DEB.1.10.0805201211390.4804@asgard.lang.hm>
In-Reply-To: <alpine.DEB.1.10.0805201211390.4804@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: Vgz6IZZZwhjuBYn-UJ-0e-leXXbRP9A9+QvvC2rq4aueFSD3l8mI-Mx5B5MIxiOQkc
X-TOI-MSGID: b21fe182-419e-45df-8202-7ccb3822527f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> 
> try killing syslog and then see if you continue to have the problem. 
> It's possible that what's happening is syslog is getting stuck and su is 
> sitting waiting for syslog to process the log entry.
> 

No improvement: I killed syslogd, and yet stty gets stuck.

But surely it was a smart idea.


Regards

Harri

