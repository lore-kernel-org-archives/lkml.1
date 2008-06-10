Return-Path: <linux-kernel-owner+w=401wt.eu-S1758156AbYFJI10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156AbYFJI10 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 04:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbYFJI1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 04:27:18 -0400
Received: from lucidpixels.com ([75.144.35.66]:37687 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbYFJI1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 04:27:17 -0400
Date: Tue, 10 Jun 2008 04:27:15 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
Subject: Setting system clock... (FREEZE) (2.6.25.5)
Message-ID: <alpine.DEB.1.10.0806100425570.28343@p34.internal.lan>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

http://www.linuxquestions.org/questions/linux-general-1/hard-freeze-on-boot-between-setting-clock-and-host-name-625494/

Setting system clock... (FREEZE)

Then, I power cycle the host and it comes up OK, per the above will 
disable network console support and stop using it, hopefully this solves 
the problem.

I am not using it elsewhere and have not seen this issue.

At the moment, using: 2.6.25.5 (Debian Testing)

Going to 2.6.25.6 w/network logging disabled.

Was curious though if anyone on the list has seen something similar to 
this and can confirm if it is indeed the network console logging?

Thanks,

Justin.
