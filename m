Return-Path: <linux-kernel-owner+w=401wt.eu-S1762352AbYHERWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762352AbYHERWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 13:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760727AbYHERUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 13:20:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53893 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756175AbYHERUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 13:20:05 -0400
Date: Tue, 5 Aug 2008 13:19:42 -0400 (EDT)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, v4l-dvb-maintainer@linuxtv.org,
       video4linux-list@redhat.com, Ralf Baechle <ralf@linux-mips.org>,
       linux-mips@linux-mips.org
Subject: Re: v4l/mips build problem
In-Reply-To: <20080806023906.c2f919b4.sfr@canb.auug.org.au>
Message-ID: <alpine.LFD.1.10.0808051315440.22576@bombadil.infradead.org>
References: <20080806012357.55625daf.sfr@canb.auug.org.au> <20080805154122.GC22895@cs181140183.pp.htv.fi> <20080806020647.2cf11a2b.sfr@canb.auug.org.au> <20080805092650.af88364a.akpm@linux-foundation.org> <20080806023906.c2f919b4.sfr@canb.auug.org.au>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Aug 2008, Stephen Rothwell wrote:

> Hi Andrew,
>
> On Tue, 5 Aug 2008 09:26:50 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>> yup, I'll send it in unless it turned up in today's linux-next.
>
> Which I think is unlikely:  the v4l/dvb tree has been unmergable since
> 29/7 and I haven't heard from Mauro since then.
Too busy during those days. I don't mind if Andrew prefer to forward this 
directly, but I have another bunch of patches to send Linus probably 
today.

I did some changes on the procedures I use for sending patches upstream, 
but I want to do some additional tests here to be sure that everything is 
all right. The idea is never rebase my main branches again.

-- 
Cheers,
Mauro Carvalho Chehab
http://linuxtv.org
mchehab@infradead.org
