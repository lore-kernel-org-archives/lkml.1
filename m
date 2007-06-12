Return-Path: <linux-kernel-owner+w=401wt.eu-S1757475AbXFLBSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475AbXFLBSj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 21:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756399AbXFLBSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 21:18:31 -0400
Received: from quechua.inka.de ([193.197.184.2]:36621 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756135AbXFLBSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 21:18:31 -0400
From: Bernd Eckenfels <ecki@lina.inka.de>
To: linux-kernel@vger.kernel.org
Subject: Re: ext2 on flash memory
Organization: Private Site running Debian GNU/Linux
In-Reply-To: <11f674920706111735l7dec2136t32d40ee2ab4ccca4@mail.gmail.com>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.7.8-20050315 ("Scalpay") (UNIX) (Linux/2.6.13.4 (i686))
Message-Id: <E1Hxv1g-0000X1-00@calista.eckenfels.net>
Date: Tue, 12 Jun 2007 03:18:28 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In article <11f674920706111735l7dec2136t32d40ee2ab4ccca4@mail.gmail.com> you wrote:
> All of the posts fail to address the question here: what is the
> correct file system, or does one exist yet, for wear leveling flash
> storage.  JFFS2 and logfs are nice for MTD, but for better flash
> memories that are likely to be used in the future like solid state
> hard disks, what is the answer?

FAT - you can stick it into Windows Boxes on the road.

Bernd
