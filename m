Return-Path: <linux-kernel-owner+w=401wt.eu-S1760294AbXFSRiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760294AbXFSRiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 13:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758080AbXFSRis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 13:38:48 -0400
Received: from barikada.upol.cz ([158.194.242.200]:36485 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682AbXFSRir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 13:38:47 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adrian Bunk <bunk@stusta.de>, Martin Bligh <mbligh@mbligh.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       "Fortier,Vincent [Montreal]" <Vincent.Fortier1@ec.gc.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: This is [Re:] How to improve the quality of the kernel[?].
In-Reply-To: <alpine.LFD.0.98.0706190949440.3593@woody.linux-foundation.org>
References: <20070617220927.99ebc1ee.akpm@linux-foundation.org> <F1D642E5A91BC94D9504EC83AE19E6B0128A0D@ecqcmtlmail3.quebec.int.ec.gc.ca> <32209efe0706181531x5322533dr31dc90e6dd8c7973@mail.gmail.com> <46770A22.4020007@mbligh.org> <32209efe0706181556l2ed378f4sf520c3852f398fa4@mail.gmail.com> <46771C5D.10809@mbligh.org> <alpine.LFD.0.98.0706181706470.3593@woody.linux-foundation.org> <E1I0UzP-0004AY-Hy@flower> <20070619124855.GB12950@stusta.de> <alpine.LFD.0.98.0706190732150.3593@woody.linux-foundation.org> <20070619165300.GD19904@flower.upol.cz> <alpine.LFD.0.98.0706190949440.3593@woody.linux-foundation.org>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: jed (x86_64-pc-linux-glibc-debian)
X-Mailer: slrn
Date: Tue, 19 Jun 2007 19:51:21 +0200
Message-Id: <E1I0hrN-0003Z5-14@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Date: Tue, 19 Jun 2007 10:04:58 -0700 (PDT)
> 
> On Tue, 19 Jun 2007, Oleg Verych wrote:
>> 
>> I'm proposing kind of smart tracking, summarized before. I'm not an
>> idealist, doing manual work. Making tools -- is what i've picked up from
>> one of your mails. Thus hope of having more opinions on that.
>
> Don't get me wrong, I wasn't actually responing to you personally, I was 
> actually responding mostly to the tone of this thread.

By reading only known persons[1]? Fine, it is OK.

But i hope, i did useful statements. In fact, noise reduction stuff WRT
bug reports was before in my analysis of Adrian's POV here (reportbug
tool). Also it showed again, when i've wrote about traces, where testers
(bug reporters) can find test cases, before they will cry (again) about
some issues. I see this, example is bugzilla @ mozilla -- known history.

[1] Noise filtering -- that's obvious for me, after all :)

By not flaming further, i'm just going to try to implement something.
Hopefully my next patch will be usefully smart tracked.

Thanks!
____
