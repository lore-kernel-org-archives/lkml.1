Return-Path: <linux-kernel-owner+w=401wt.eu-S1755219AbYEERdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbYEERdq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 13:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbYEERdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 13:33:35 -0400
Received: from outbound-mail-125.bluehost.com ([67.222.38.25]:51909 "HELO
	outbound-mail-125.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752065AbYEERde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 13:33:34 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] default to n for GROUP_SCHED and FAIR_GROUP_SCHED
Date: Mon, 5 May 2008 10:33:12 -0700
User-Agent: KMail/1.9.9
Cc: Parag Warudkar <parag.warudkar@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "akpm@osdl.org" <akpm@osdl.org>, Peter Zijlstra <peterz@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
References: <82e4877d0805031742o464dd581wd93173d79705ce0d@mail.gmail.com> <82e4877d0805050814j721ae522k84384df48c9f4336@mail.gmail.com> <20080505172146.GB22332@elte.hu>
In-Reply-To: <20080505172146.GB22332@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805051033.12820.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 05, 2008 10:21 am Ingo Molnar wrote:
> * Parag Warudkar <parag.warudkar@gmail.com> wrote:
> > sched-devel does not boot on my machine - stops right after PCI: Not
> > using mmconfig.
>
> does -git boot fine - or is this a regression relative to v2.6.25?
>
> I just built your config on latest sched-devel and booted it on two
> 64-bit testboxes and it boots just fine.
>
> could you send your -git bootup log?

Can you also try booting with initcall_debug?
