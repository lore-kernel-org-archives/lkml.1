Return-Path: <linux-kernel-owner+w=401wt.eu-S1757682AbYEDUPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682AbYEDUPE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 16:15:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754655AbYEDUOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 16:14:53 -0400
Received: from quechua.inka.de ([193.197.184.2]:58501 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679AbYEDUOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 16:14:52 -0400
From: Bernd Eckenfels <ecki@lina.inka.de>
To: linux-kernel@vger.kernel.org
Subject: Re: kconfig - a suggestion how to fix the select issue
Organization: Private Site running Debian GNU/Linux
In-Reply-To: <481E0E76.3060900@gmail.com>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.7.8-20050315 ("Scalpay") (UNIX) (Linux/2.6.13.4 (i686))
Message-Id: <E1Jskbi-00058h-00@calista.eckenfels.net>
Date: Sun, 04 May 2008 22:14:50 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In article <481E0E76.3060900@gmail.com> you wrote:
> I've always really disliked the visibility thing. I believe it's not really 
> the core issue here but regardless of anything else, could we not "grey out" 
> non-selectable options with its helpt text still available? That's much more 
> the standard UI paradigm.

And beside that nothing stops us from verifying the dependencies of the
options after select is applied and refusing to save the (broken) config.

Gruss
Bernd
