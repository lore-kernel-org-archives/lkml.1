Return-Path: <linux-kernel-owner+w=401wt.eu-S1756468AbXELDST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756468AbXELDST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 23:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbXELDSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 23:18:13 -0400
Received: from quechua.inka.de ([193.197.184.2]:52621 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbXELDSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 23:18:12 -0400
From: Bernd Eckenfels <ecki@lina.inka.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [patch] ip_local_port_range sysctl has annoying default
Organization: Private Site running Debian GNU/Linux
In-Reply-To: <46452301.4060306@zytor.com>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.7.8-20050315 ("Scalpay") (UNIX) (Linux/2.6.13.4 (i686))
Message-Id: <E1Hmi7W-0007Ka-00@calista.eckenfels.net>
Date: Sat, 12 May 2007 05:18:10 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In article <46452301.4060306@zytor.com> you wrote:
> However, there are a large number of applications which have registered
> ports in this range.

And some application who request random listening ports actually query the
/etc/services file to ensure it is a "unnamed" port.

Gruss
Bernd
