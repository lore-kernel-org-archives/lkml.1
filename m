Return-Path: <linux-kernel-owner+w=401wt.eu-S1946636AbXBIQ7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946636AbXBIQ7r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:59:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946630AbXBIQ7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:59:47 -0500
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:6165 "EHLO
	outbound8-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946636AbXBIQ7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:59:46 -0500
X-BigFish: V
Message-ID: <45CCA537.9010801@am.sony.com>
Date: Fri, 09 Feb 2007 08:45:43 -0800
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Mozilla Thunderbird 1.0.8-1.1.fc4 (X11/20060501)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: torvalds@linux-foundation.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ps3: missing exports
References: <E1HFYFb-0004rm-0y@ZenIV.linux.org.uk>
In-Reply-To: <E1HFYFb-0004rm-0y@ZenIV.linux.org.uk>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2007 16:45:43.0387 (UTC) FILETIME=[BD4262B0:01C74C69]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
---
 arch/powerpc/platforms/ps3/interrupt.c  |    2 ++
 arch/powerpc/platforms/ps3/system-bus.c |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)


Acked-by: Geoff Levand <geoffrey.levand@am.sony.com>

