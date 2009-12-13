Return-Path: <linux-kernel-owner+w=401wt.eu-S1753899AbZLMTFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbZLMTFb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 14:05:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753851AbZLMTFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 14:05:30 -0500
Received: from blu0-omc1-s4.blu0.hotmail.com ([65.55.116.15]:4744 "HELO
	blu0-omc1-s4.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753848AbZLMTFa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 14:05:30 -0500
Message-ID: <BLU118-W2048C3510A781E30899013E68A0@phx.gbl>
X-Originating-IP: [78.23.100.244]
From: Nico <segfault2@hotmail.com>
To: <linux-kernel@vger.kernel.org>
Subject: ksoftirqd problem
Date: Sun, 13 Dec 2009 20:05:29 +0100
Importance: Normal
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 13 Dec 2009 19:05:29.0531 (UTC) FILETIME=[3C92E8B0:01CA7C27]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I recently switched to kernel 2.6.32 (self configured/compiled) and I've noticed an odd behavior on one of my servers. I run a bittorrent tracker on one of my servers and when using kernel 2.6.32, every now and then ksoftirqd will jump up to 20% of my CPU for almost a minute. The tracker has a total peers amount of ~45000 peers (if it matters) and this behavior seems to only happen under kernel 2.6.32. Switching back to kernel 2.6.31.1 on the server, ksoftirdq does not behave that way.

Any thoughts?

PS: please CC me as I'm not subscribed to the list

Thanks :)
 		 	   		  
_________________________________________________________________
Windows Live: Friends get your Flickr, Yelp, and Digg updates when they e-mail you.
http://www.microsoft.com/middleeast/windows/windowslive/see-it-in-action/social-network-basics.aspx?ocid=PID23461::T:WLMTAGL:ON:WL:en-xm:SI_SB_3:092010