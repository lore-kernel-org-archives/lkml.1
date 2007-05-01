Return-Path: <linux-kernel-owner+w=401wt.eu-S965632AbXEAIXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965632AbXEAIXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 04:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031032AbXEAIXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 04:23:51 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:47012 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965632AbXEAIXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 04:23:50 -0400
Message-ID: <4636F90A.2070303@interia.pl>
Date: Tue, 01 May 2007 10:23:38 +0200
From: =?UTF-8?B?UmFmYcWCIEJpbHNraQ==?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 1.5.0.10 (X11/20070321)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Natsemi DP83815 driver spaming
References: <46365887.3010705@interia.pl> <20070430205522.abad2481.akpm@linux-foundation.org> <4636E970.3010602@interia.pl>
In-Reply-To: <4636E970.3010602@interia.pl>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-EMID: 43862acc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello again,

I have downloaded DP83815 datasheet and I see that
> eth0: Wake-up event 0x200000a
means "broadcast received" and wakup on broadcast and 
unicast enabled.
> eth0: Wake-up event 0x80000a
Above means "unicast received" and wakup on broadcast 
and unicast enabled.
I will try to check if disabling wakeup makes any difference.

Rafał


----------------------------------------------------------------------
Zrob numer kumplom >> http://link.interia.pl/f1a5d

