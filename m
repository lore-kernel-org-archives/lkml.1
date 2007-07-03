Return-Path: <linux-kernel-owner+w=401wt.eu-S1758665AbXGCIGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758665AbXGCIGy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 04:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754274AbXGCIGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 04:06:45 -0400
Received: from mithrandir.softwarenexus.net ([66.98.186.96]:4716 "EHLO
	mail.genesi-usa.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683AbXGCIGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 04:06:44 -0400
X-Greylist: delayed 2869 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Jul 2007 04:06:44 EDT
Message-ID: <4689F886.6070000@genesi-usa.com>
Date: Tue, 03 Jul 2007 08:19:34 +0100
From: Matt Sealey <matt@genesi-usa.com>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Fusion MPT regression, fixed or not?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello World,

I re-stumbled on this installing Gentoo on VMware today;

http://lkml.org/lkml/2007/3/23/312

It doesn't seem to be fixed in 2.6.22-rc7, but I might be mistaken
somehow. Has anyone done any work on this or looked at the problem
in more detail? The trail seems to die at that thread.

It is affecting VMware for me mainly but a lot of heavy server
hardware seems to use the chip, in fact some I am looking at right
now to recommend purchasing on.. I'd really like to use the latest
kernel because virtualisation is the key (dynamic ticks and
tickless hz and the latest virtualisation options would help eke out
more value ;)

-- 
Matt Sealey <matt@genesi-usa.com>
Genesi, Manager, Developer Relations
