Return-Path: <linux-kernel-owner+w=401wt.eu-S1761268AbYEQXS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761268AbYEQXS4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 19:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756719AbYEQXSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 19:18:50 -0400
Received: from sandeen.net ([209.173.210.139]:19765 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753199AbYEQXSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 19:18:49 -0400
Message-ID: <482F67D9.70400@sandeen.net>
Date: Sat, 17 May 2008 18:18:49 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: David Greaves <david@dgreaves.com>
CC: David Chinner <dgc@sgi.com>, LinuxRaid <linux-raid@vger.kernel.org>,
       xfs@oss.sgi.com,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: Re: Regression- XFS won't mount on partitioned md array
References: <482DC043.5000307@dgreaves.com> <482DD981.5070004@sandeen.net> <482EEFDA.50101@dgreaves.com> <482EF6A7.2020909@sandeen.net>
In-Reply-To: <482EF6A7.2020909@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen wrote:

> I'll see if I have a little time today to track down the problem.


Does this patch fix it for you?  Does for me though I can't yet explain
why ;)

http://www.linux.sgi.com/archives/xfs/2008-05/msg00190.html

-Eric
