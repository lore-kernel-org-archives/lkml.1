Return-Path: <linux-kernel-owner+w=401wt.eu-S934402AbZJMVdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934402AbZJMVdo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 17:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761449AbZJMVdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 17:33:44 -0400
Received: from lucidpixels.com ([75.144.35.66]:55075 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753877AbZJMVdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 17:33:43 -0400
Date: Tue, 13 Oct 2009 17:33:06 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.31.3: Machine hangs at reboot (Intel DP55KG motherboard)
Message-ID: <alpine.DEB.2.00.0910131723510.5034@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

When I reboot my system, it hangs:
http://home.comcast.net/~jpiszcz/20091013/system-hangs-at-reboot.jpg

It says...

Restarting system.
machine restart

Then it sits there and does nothing.

Has anyone seen this before?

BTW-- Thanks for the INTEL network driver info, running 1.0.15-NAPI and 
its working nicely, can't wait until its included in the upstream release.

Justin.
