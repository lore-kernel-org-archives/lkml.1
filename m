Return-Path: <linux-kernel-owner+w=401wt.eu-S1757790AbYDSTr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757790AbYDSTr5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 15:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755446AbYDSTrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 15:47:49 -0400
Received: from cpsmtpo-eml01.kpnxchange.com ([213.75.38.150]:8775 "EHLO
	cpsmtpo-eml01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754769AbYDSTrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 15:47:48 -0400
From: Frans Pop <elendil@planet.nl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [git pull] scheduler changes for v2.6.26
Date: Sat, 19 Apr 2008 21:47:42 +0200
User-Agent: KMail/1.9.9
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
References: <20080419181304.GB21353@elte.hu>
In-reply-To: <20080419181304.GB21353@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804192147.43719.elendil@planet.nl>
X-OriginalArrivalTime: 19 Apr 2008 19:47:46.0004 (UTC) FILETIME=[3D56B940:01C8A256]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Ingo Molnar (12):
>       sched: re-do "sched: fix fair sleepers"

Has the regression [1] that was traced to this change been fixed now?

The regression was confirmed to be also present in sched-devel.git at the 
time of -rc8, so I'd expect it still to be valid unless of course the cause 
was found since then.

Cheers,
FJP

[1] http://bugzilla.kernel.org/show_bug.cgi?id=10428
