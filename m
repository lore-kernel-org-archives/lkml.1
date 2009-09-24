Return-Path: <linux-kernel-owner+w=401wt.eu-S1752334AbZIXMbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334AbZIXMbx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 08:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbZIXMbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 08:31:52 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:51073 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751720AbZIXMbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 08:31:52 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqIEABcEu0pMROOX/2dsb2JhbACBUtR+hBsFgVg
Date: Thu, 24 Sep 2009 08:31:54 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org
Subject: Immediate values
Message-ID: <20090924123154.GA12907@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 08:28:38 up 36 days, 23:18,  2 users,  load average: 0.20, 0.18,
	0.17
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Andi asked me this week when we should expect to see the "immediate
values" make it into mainline. I remember you pulled them at one point.
He would like to use them to encode some very hot-path variables into
the instruction stream.

How should I proceed to get that upstream ? Would a repost be
appropriate ?

I have support for powerpc, x86 ans sparc64 currently.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
