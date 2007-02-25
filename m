Return-Path: <linux-kernel-owner+w=401wt.eu-S965089AbXBYTH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965089AbXBYTH3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 14:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965115AbXBYTH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 14:07:29 -0500
Received: from [212.12.190.62] ([212.12.190.62]:32936 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S965089AbXBYTH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 14:07:28 -0500
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Date: Sun, 25 Feb 2007 22:10:19 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200702252210.19518.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> if you create a threadlet based test-webserver, could you please do a
> comparable kevents implementation as well? I.e. same HTTP parser (or
> non-parser, as usually the case is with prototypes ;). Best would be
> something that one could trigger between threadlet and kevent mode,
> using the same binary :-)

Now, why would you want this?

Is there some performance issue with separately loaded binaries?


Thanks!

--
Al

