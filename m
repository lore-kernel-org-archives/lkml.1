Return-Path: <linux-kernel-owner+w=401wt.eu-S1759265AbYF2Iot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759265AbYF2Iot (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 04:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758085AbYF2Ioj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 04:44:39 -0400
Received: from quechua.inka.de ([193.197.184.2]:54115 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758079AbYF2Ioi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 04:44:38 -0400
X-Greylist: delayed 1472 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Jun 2008 04:44:38 EDT
From: Bernd Eckenfels <ecki@lina.inka.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UTC timestamp option for FAT filesystems
Organization: Private Site running Debian GNU/Linux
In-Reply-To: <4867178D.50106@skyrush.com>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.7.8-20050315 ("Scalpay") (UNIX) (Linux/2.6.13.4 (i686))
Message-Id: <E1KCs8h-0002dY-00@calista.eckenfels.net>
Date: Sun, 29 Jun 2008 10:20:03 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In article <4867178D.50106@skyrush.com> you wrote:
> So I guess my point is that the option I propose will allow people to
> set their cameras to UTC and thereby always get unambiguously correct
> timestamps.  Plus there is no need to ever change the camera's clock
> when traveling or when DST changes happen.  Not all people will choose
> to operate this way, so it would be nice to have the choice.

And just as a reminder, tools tend to use EXIF informations anyway.

Gruss
Bernd
