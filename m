Return-Path: <linux-kernel-owner+w=401wt.eu-S1753950AbYANBIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbYANBIf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 20:08:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbYANBI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 20:08:26 -0500
Received: from quechua.inka.de ([193.197.184.2]:59307 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280AbYANBIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 20:08:25 -0500
X-Greylist: delayed 1883 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Jan 2008 20:08:25 EST
From: Bernd Eckenfels <ecki@lina.inka.de>
To: linux-kernel@vger.kernel.org
Subject: Re: The ext3 way of journalling
Organization: Private Site running Debian GNU/Linux
In-Reply-To: <20080113222310.GA20815@jolt.modeemi.cs.tut.fi>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.7.8-20050315 ("Scalpay") (UNIX) (Linux/2.6.13.4 (i686))
Message-Id: <E1JEDJz-0005gd-00@calista.eckenfels.net>
Date: Mon, 14 Jan 2008 01:36:59 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In article <20080113222310.GA20815@jolt.modeemi.cs.tut.fi> you wrote:
> Just to clarify, I had about 60 days of uptime, and hence at least
> 60 days since the last FS check/mount/etc., when Linux crashed those
> few days ago, and wanted to start checking disks with "9192 days since
> last file system check".

This, however sounds like a typical "RTC has forgotten time" problem which
is typical for some motherboards. 9192days is very close to 1984. I never
see any coruption like that, but broken BIOS clocks quite often.

Gruss
Bernd

