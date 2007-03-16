Return-Path: <linux-kernel-owner+w=401wt.eu-S965967AbXCPVv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965967AbXCPVv5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 17:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965966AbXCPVv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 17:51:57 -0400
Received: from [212.12.190.214] ([212.12.190.214]:32918 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S965967AbXCPVv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 17:51:56 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: ASR: Address Space Randomization (was: [RFC, PATCH] Fixup COMPAT_VDSO to work with CONFIG_PARAVIRT)
Date: Sat, 17 Mar 2007 00:55:17 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200703170055.18047.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ebiederm wrote:
> I'm tempted to rant on the pure insanity of address space randomization
> but that is a whole other issue...

Please do rant; all I can see asr brings is one big performance hit.

Of course, it's not enough to just attack this at the kernel, but glibc has 
to play accordingly as well.


Thanks!

--
Al

