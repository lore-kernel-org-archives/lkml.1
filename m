Return-Path: <linux-kernel-owner+w=401wt.eu-S1760862AbYFSMwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760862AbYFSMwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 08:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754731AbYFSMwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 08:52:09 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:55475 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756206AbYFSMwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 08:52:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ar4EAOnxWUhMQW1O/2dsb2JhbACBWq5T
Date: Thu, 19 Jun 2008 08:51:57 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: lttng git.kernel.org tree
Message-ID: <20080619125157.GA14561@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:43:42 up 14 days, 17:24,  2 users,  load average: 2.18, 2.30,
	1.42
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

I've been posting my LTTng work through patchsets for a while, but I
start to think it would be good to deploy a LTTng tree on
git.kernel.org, do you agree ?

Also, I guess I might have to do frequent rebases to follow mainline
because the LTTng patchset touches a lot of files (including the
low-level stuff, the architecture independant and arch. specific
instrumentation and the tracer itself). My current diffstat states :

 271 files changed, 10319 insertions(+), 674 deletions(-)

in 118 patches.

Is there some documentation that describes what would be the best way to
manage such a tree ? (frequent rebases or not ?)

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
