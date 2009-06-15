Return-Path: <linux-kernel-owner+w=401wt.eu-S1754614AbZFOEP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbZFOEP0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 00:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750801AbZFOEPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 00:15:16 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:58431 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbZFOEPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 00:15:15 -0400
Message-ID: <57829.166.70.238.43.1245036804.squirrel@webmail.wolfmountaingroup.com>
Date: Sun, 14 Jun 2009 21:33:24 -0600 (MDT)
Subject: Xen vs. KVM
From: jmerkey@wolfmountaingroup.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Personally, they are nothing but piracy tools used to hijack and run
multiple hijacked copies of windows -- even in reputable systems houses.

I was working on VM/ESA and mainframe operating systems before linux even
existed and am familar with the issues.

I have worked with both KVM and XEN and to be honest, XEN is infested with
bugs -- mostly of the paging type -- and you need an logic analyzer of an
ICE to debug some of it.  I have nothing but trouble with it.  KVM is more
stable but also sucks on performance, but I occasionally see the same
issues.

I have worked with several local clients wanting to use both, and they are
idiots as near as I can tell.  What fucking moron would want to cram 12 OS
images on a system at once so they can run PHP and nysql apps between
windows and Linux?  This is what these stupid goofs are doing.

Folks are better off with VMWare (which is a lot slower) and more stable
than either of them.    KVM is cleaner but is still not stable with all
apps.

Jeff

