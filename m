Return-Path: <linux-kernel-owner+w=401wt.eu-S1753283AbXJAINW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbXJAINW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 04:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbXJAINP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 04:13:15 -0400
Received: from quechua.inka.de ([193.197.184.2]:47605 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbXJAINO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 04:13:14 -0400
From: Bernd Eckenfels <ecki@lina.inka.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Out of memory management in embedded systems
Organization: Private Site running Debian GNU/Linux
In-Reply-To: <87odfj5krj.fsf@burp.tkv.asdf.org>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.7.8-20050315 ("Scalpay") (UNIX) (Linux/2.6.13.4 (i686))
Message-Id: <E1IcGOu-0007sH-00@calista.eckenfels.net>
Date: Mon, 01 Oct 2007 10:13:12 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In article <87odfj5krj.fsf@burp.tkv.asdf.org> you wrote:
> Make kernel configuration option? (e.g. disable "over commit"
> mis-feature :-)

# egrep . /proc/sys/vm/overcommit_*
/proc/sys/vm/overcommit_memory:0
/proc/sys/vm/overcommit_ratio:50

Gruss
Bernd
