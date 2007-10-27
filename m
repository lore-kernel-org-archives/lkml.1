Return-Path: <linux-kernel-owner+w=401wt.eu-S1755450AbXJ0PTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbXJ0PTh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 11:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbXJ0PTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 11:19:30 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:59866 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751588AbXJ0PT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 11:19:29 -0400
X-Sasl-enc: /dAMBNXBnVRoD+uPLZazU+xVa3BmNvb0VbV6IiJA8s+7 1193498368
Message-ID: <472356FC.9090302@imap.cc>
Date: Sat, 27 Oct 2007 17:19:24 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: sam@ravnborg.org
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.23-mm1] CONFIG_LOCALVERSION handling broken
References: <20071011213126.cf92efb7.akpm@linux-foundation.org> <471142A8.40307@imap.cc> <47169593.7060901@imap.cc>
In-Reply-To: <47169593.7060901@imap.cc>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

/me wrote:

> ts@xenon:~/kernel/linux-2.6.23-mm1-work> make include/config/kernel.release
> ts@xenon:~/kernel/linux-2.6.23-mm1-work> cat include/config/kernel.release
> 2.6.23-mm1-testing
> ts@xenon:~/kernel/linux-2.6.23-mm1-work> make
> [...]
> ts@xenon:~/kernel/linux-2.6.23-mm1-work> cat include/config/kernel.release
> 2.6.23-mm1
[...]
> I'll just skip this -mm release and wait for 2.6.24-rc1, hoping
> it won't have the same problem.

2.6.24-rc1 is fine, so the issue can be closed.

T.

