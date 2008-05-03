Return-Path: <linux-kernel-owner+w=401wt.eu-S1763971AbYECQQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763971AbYECQQk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 12:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753639AbYECQQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 12:16:31 -0400
Received: from quechua.inka.de ([193.197.184.2]:33411 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753369AbYECQQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 12:16:30 -0400
From: Bernd Eckenfels <ecki@lina.inka.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 10586] New: High Number of Segfaults onMacBookStarting With 2.6.24.5 Kernel
Organization: Private Site running Debian GNU/Linux
In-Reply-To: <20080502061018.5557d067.akpm@linux-foundation.org>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.7.8-20050315 ("Scalpay") (UNIX) (Linux/2.6.13.4 (i686))
Message-Id: <E1JsKNy-0001Sn-00@calista.eckenfels.net>
Date: Sat, 03 May 2008 18:14:54 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In article <20080502061018.5557d067.akpm@linux-foundation.org> you wrote:
> Traditionally i386 never printed that message (in fact neither architecture
> should - it allows poeple to spam the logs, but it is at least
> ratelimited).

Actually I like the feature that segfaults and other abort signals are
logged. On Serers where no untrusted multiple users are present this is
helpfull. Freebsd does that for a long time. Besides ratelimiting, we could
make it an runtime sysctl option, but please keep it.

The OP would have never found out about his qmail problem..

Gruss
Bernd
