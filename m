Return-Path: <linux-kernel-owner+w=401wt.eu-S1764424AbXHNRPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764424AbXHNRPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 13:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753992AbXHNRPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 13:15:31 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:52225 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbXHNRPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 13:15:30 -0400
From: Markus <lists4me@web.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] CFS scheduler, -v19
Date: Tue, 14 Aug 2007 19:15:22 +0200
User-Agent: KMail/1.9.7
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20070706173319.GA2356@elte.hu> <200708091934.10962.lists4me@web.de> <20070810074615.GC28264@elte.hu>
In-Reply-To: <20070810074615.GC28264@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708141915.23738.lists4me@web.de>
X-Provags-ID: V01U2FsdGVkX18lM3TsTUUOcVI0zFHYbaAyXTWc9EcQONq9EcCa
	04dmoXKu3HdeG4A5+iXqWm32hFrbPBDyzhc8rnnUmr3kavBLWM
	81gLhvtBY=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> could you send me your debug-info:
> 
>   http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh
> 
> just run that script on 2.6.23-rc2 system and send me the file it 
> produces. I've got a theory about what might be going on, and this 
> debug-info could help prove/disprove it.
Done by private mail on friday.

Also tried the very current linux-2.6.git (friday aswell) with 
sched-ingo-combo.patch (as told in a private answer mail).

Nothing fixed it so far.

If I can do anything...

   Markus
