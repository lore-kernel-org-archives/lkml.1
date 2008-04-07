Return-Path: <linux-kernel-owner+w=401wt.eu-S1757254AbYDGV4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254AbYDGV4G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 17:56:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbYDGVz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 17:55:58 -0400
Received: from hpsmtp-eml18.kpnxchange.com ([213.75.38.118]:43587 "EHLO
	hpsmtp-eml18.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752560AbYDGVz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 17:55:57 -0400
From: Frans Pop <elendil@planet.nl>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [rc8] Regression: key repeats and skips in music during compilation
Date: Mon, 7 Apr 2008 23:55:53 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <200804041222.35025.elendil@planet.nl> <200804071403.59500.elendil@planet.nl> <1207571115.15579.26.camel@twins>
In-Reply-To: <1207571115.15579.26.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804072355.55076.elendil@planet.nl>
X-OriginalArrivalTime: 07 Apr 2008 21:55:55.0450 (UTC) FILETIME=[27A611A0:01C898FA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 April 2008, you wrote:
> > Note that I can also reproduce the issue with a kernel that does *not*
> > have CONFIG_GROUP_SCHED set. I still get the music skips (maybe less
> > frequently, but that's hard to measure), and I've have also seen key
> > repeats once.
> >
> > Anything I can do to provide additional info on this?
>
> Could you try -rc5 !GROUP ?

Good call! Problem cannot be reproduced with -rc5 (without GROUP_SCHED set). 
Music remains smooth during the compilation.

Do you have a particular change in mind or should I still provide the trace 
info as suggested by Ingo? If so, I can probably do that tomorrow.

Cheers,
FJP
