Return-Path: <linux-kernel-owner+w=401wt.eu-S1756829AbXG2BXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829AbXG2BXf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 21:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751745AbXG2BX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 21:23:26 -0400
Received: from zaphod.dth.net ([85.159.112.68]:35220 "EHLO zaphod.dth.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679AbXG2BX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 21:23:26 -0400
Date: Sun, 29 Jul 2007 03:23:24 +0200
From: Danny ter Haar <dth@dth.net>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ide problems: 2.6.22-git17 working, 2.6.23-rc1* is not
Message-ID: <20070729012324.GA29723@dth.net>
References: <20070727193832.GA20289@dth.net> <200707290142.53689.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707290142.53689.bzolnier@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Bartlomiej Zolnierkiewicz (bzolnier@gmail.com):
> Please retry with the latest -git kernel and if the problem is still
> there install git, get kernel tree and run git-bisect.

I ran over "make menuconfig" and did a few changes.

http://www.dth.net/kernel/config-2.6.23-rc1-git5

It boots, but freezes solid before doing any "work" as a firewall.
I was able to catch boot messages with netconsole

http://www.dth.net/kernel/via_output_2.6.23-rc1-git5

It didn't respond after the last line.
magig sysrq etc, all nada.

Will start to get acquainted with git ;-)

Danny
-- 
