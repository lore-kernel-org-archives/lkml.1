Return-Path: <linux-kernel-owner+w=401wt.eu-S967826AbYD1XGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967826AbYD1XGY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 19:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967171AbYD1Wla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 18:41:30 -0400
Received: from gwauna.smsarena.net ([62.57.106.24]:42087 "EHLO diginvestra.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S967137AbYD1Wl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:41:28 -0400
X-Greylist: delayed 847 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Apr 2008 18:41:28 EDT
Date: Tue, 29 Apr 2008 00:27:15 +0200 (CEST)
From: Pau Aliagas <linuxnow@newtral.org>
X-X-Sender: pau@tux.dis.ct
To: lkml <linux-kernel@vger.kernel.org>
Subject: can I receive UDP broadcasts in aliases interfaces?
Message-ID: <alpine.LFD.1.00.0804290021170.11820@tux.dis.ct>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I'm trying to use aliased interfaces to run multiple instances of a 
process that receives UDP broadcasts; I want to test all in a single 
computer when I have no access to the network.

My problem is that I can bind to the virtual interface ip to send and 
receive packets, but I don't receive udp broadcasts. I have no firewall 
rules that block it and udp bcasts are generated from the same computer 
too.

Is there any sysctl param I need to change? I'm usre this can be done but 
I haven't found how.

Thanks
Pau
