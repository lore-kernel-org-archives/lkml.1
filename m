Return-Path: <linux-kernel-owner+w=401wt.eu-S1030905AbXDPTVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030905AbXDPTVl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 15:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030909AbXDPTVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 15:21:41 -0400
Received: from quechua.inka.de ([193.197.184.2]:41769 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030905AbXDPTVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 15:21:40 -0400
From: Bernd Eckenfels <ecki@lina.inka.de>
To: linux-kernel@vger.kernel.org
Subject: Re: ZFS with Linux: An Open Plea
Organization: Private Site running Debian GNU/Linux
In-Reply-To: <4623BE2E.2020800@s5r6.in-berlin.de>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.7.8-20050315 ("Scalpay") (UNIX) (Linux/2.6.13.4 (i686))
Message-Id: <E1HdWld-0003oC-00@calista.eckenfels.net>
Date: Mon, 16 Apr 2007 21:21:37 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In article <4623BE2E.2020800@s5r6.in-berlin.de> you wrote:
> I meant that the central requirement on the design and implementation of
> audio subsystems is an (ideally guaranteed) bounded maximum of
> latencies; and that's exactly the major point where I heard that there
> are problems with ALSA driver components in userspace.  You were talking
> about throughput of storage systems, for which latencies of the software
> part of the stack do not play such a central role.  Therefore your
> comparison appeared off the mark to me.

Unfortunatelle Latency is critical for a number of critical applications
like databases or file based transaction systems (mail, news) - mainly the
users of fsync().

Gruss
Bernd
