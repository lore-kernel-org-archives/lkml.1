Return-Path: <linux-kernel-owner+w=401wt.eu-S1761547AbXKMUUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761547AbXKMUUW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 15:20:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756215AbXKMUUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 15:20:06 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:49591 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756631AbXKMUUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 15:20:05 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAEeVOUdMROHU/2dsb2JhbACBWw
Date: Tue, 13 Nov 2007 15:20:02 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>
Subject: LTTng (Linux kernel tracer) tarball, 0.10.0-pre24
Message-ID: <20071113202002.GA6286@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:11:10 up 10 days,  1:16,  5 users,  load average: 0.48, 0.86,
	1.10
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have seen a few threads about unfixed kernel regression lately. I
strongly believe that many kernel developers and users could help
pinpointing the cause of those bugs much more efficiently by using a
tool like LTTng.

If you want to find the code I just released (both for -mm inclusion and
as a RFC) tied up in a single tarball, you will find the patchset at the
beginning of the LTTng series file there :

http://ltt.polymtl.ca/lttng/patch-2.6.24-rc2-git3-lttng-0.10-pre24.tar.bz2

This LTTng "pre" version can be used with the following userspace packages :
http://ltt.polymtl.ca/lttng/ltt-control-0.46-06112007.tar.gz
http://ltt.polymtl.ca/packages/lttv-0.10.0-pre2-07112007.tar.gz

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
