Return-Path: <linux-kernel-owner+w=401wt.eu-S1946135AbXBPUef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946135AbXBPUef (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 15:34:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946139AbXBPUef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 15:34:35 -0500
Received: from dev.kryptiva.com ([69.70.52.243]:18700 "EHLO mail.kryptiva.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946135AbXBPUee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 15:34:34 -0500
X-Greylist: delayed 1431 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Feb 2007 15:34:34 EST
Message-ID: <45D61361.6030200@kryptiva.com>
Date: Fri, 16 Feb 2007 15:26:09 -0500
From: Karim Yaghmour <karim.yaghmour@kryptiva.com>
Reply-To: karim.yaghmour@kryptiva.com
Organization: Kryptiva Inc.
User-Agent: Thunderbird 1.5.0.8 (X11/20061107)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@redhat.com>,
       systemtap@sources.redhat.com, ltt-dev@shafik.org
Subject: Re: Re: [PATCH 05/05] Linux Kernel Markers, non optimized architectures
References: <1171224207118-git-send-email-mathieu.desnoyers@polymtl.ca> <1171224209195-git-send-email-mathieu.desnoyers@polymtl.ca> <20070214231635.091c7169.akpm@linux-foundation.org> <20070215190919.GA31359@Krystal>
In-Reply-To: <20070215190919.GA31359@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

----- KRYPTIVA PACKAGED MESSAGE -----
PACKAGING TYPE: SIGNED

Mathieu Desnoyers wrote:
 > The main goal of this config option is for embedded systems which doesn't support live code modification. Maybe we can put that under "embedded sytems" menu ?

Not sure whether you had had other feedback on this elsewhere in
the rest of the thread, but yes, this would make sense if the
"embedded" angle is the only reason we need this (and not, say,
performance, etc.) Also, having done that, maybe it would make
some sense to have it be a "disable" rather than "enable":
CONFIG_MARKERS_DISABLE_OPTIMIZATION?

Karim


----- KRYPTIVA SIGNED MESSAGE -----
This email claims to have been packaged by Kryptiva.
To process this email and authenticate its origin, get
the free plugin from:
http://www.kryptiva.com/downloads

----- KRYPTIVA SIGNATURE START -----
AvWVqAAAAAIAAAABAAAAAAAATiACAQAAAAC3AQAIAAAAAgAAAAECABTXxT4xHdR4/1uU1hL2
+TaPrqNB0wMAFNa8GHXZWJH5Dz+D76vfh6JhvWLvBAAUpuIZcCAkCC+ldyaBuoAWxK50HiQF
ABRI38gc/foDHQsS6X3W0VP4xTukBwYAFDzvzh+u6zVtolglAZrnE7FOmtZDBwAUTxyTas6N
WLapdnSnAwVHeC06/ioRABgAAAAAAABOIEXWD8AACTdnAAAAAAAAAN8TAAQAAAAAAAAAggP+
K8Gk1SWj+c67jiJerodkr1gntoa9dJVVN6InxB824CfKC6flE4JMWtffw0Dxh0cJ8iOQ8UeC
zoWzTs9Z+K9j1CL11CHkIIit3RK3hnfnby6whr4xoZ9UX/BUUv8FVKZeyRg7SbDKlhEZTwIH
7axjVQJ6MGU7h+0/5dKCDMEtzPY=
----- KRYPTIVA SIGNATURE END -----
