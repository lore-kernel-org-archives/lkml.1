Return-Path: <linux-kernel-owner+w=401wt.eu-S1753534AbYJUCis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbYJUCis (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 22:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbYJUCik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 22:38:40 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3999 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbYJUCij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 22:38:39 -0400
Subject: Re: [PATCH 1/3] Add file patterns to MAINTAINERS
From: Joe Perches <joe@perches.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Pavel Machek <pavel@suse.cz>,
       Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= <ukleinek@strlen.de>
In-Reply-To: <9929d2390810201858m39cd46demfc6b61f81a93650f@mail.gmail.com>
References: <1224541704-30357-1-git-send-email-joe@perches.com>
	 <1224541704-30357-2-git-send-email-joe@perches.com>
	 <9929d2390810201858m39cd46demfc6b61f81a93650f@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 20 Oct 2008 19:38:35 -0700
Message-Id: <1224556715.12101.95.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0-2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-20 at 18:58 -0700, Jeff Kirsher wrote:
> Your missing
> 
> drivers/net/e1000e/
> drivers/net/igb/
> drivers/net/ixgbe/
> 
> for the INTEL ETHERNET DRIVERS (e100/e1000/e1000e/igb/ixgb/ixgbe)

Thanks.

I added 2 of those in patch 3 of 3

+F:     drivers/net/e1000e/
 F:     drivers/net/ixgb/
+F:     drivers/net/ixgbe/
 
When Linus accepts the series, I'll do whatever
cleanup patches are required.

I'll add driver/net/igb for INTEL ETHERNET DRIVERS.

cheers, Joe

