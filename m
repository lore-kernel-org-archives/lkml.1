Return-Path: <linux-kernel-owner+w=401wt.eu-S1756095AbXIVOdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095AbXIVOdH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 10:33:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbXIVOc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 10:32:56 -0400
Received: from quechua.inka.de ([193.197.184.2]:33766 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959AbXIVOc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 10:32:56 -0400
From: Bernd Eckenfels <ecki@lina.inka.de>
To: linux-kernel@vger.kernel.org
Subject: Re: RFC: A revised timerfd API
Organization: Private Site running Debian GNU/Linux
In-Reply-To: <46F514C9.5010208@gmx.net>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.7.8-20050315 ("Scalpay") (UNIX) (Linux/2.6.13.4 (i686))
Message-Id: <E1IZ62P-0000EX-00@calista.eckenfels.net>
Date: Sat, 22 Sep 2007 16:32:53 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In article <46F514C9.5010208@gmx.net> you wrote:
>  1. This design stretches the POSIX timers API in strange
>     ways.

Maybe it is possible to reimplement the POSIX API in usermode using the
kernel's FD implementation? (and drop the posix support from kernel)

Gruss
Bernd
