Return-Path: <linux-kernel-owner+w=401wt.eu-S1755601AbZGEJCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601AbZGEJCu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 05:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752739AbZGEJCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 05:02:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:36863 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088AbZGEJCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 05:02:43 -0400
Subject: Re: [PATCH 4/6 -tip] perf_counter: Add Generalized Hardware
 interrupt support for AMD
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20090705080459.GA11636@elte.hu>
References: <1246440909.3403.5.camel@hpdv5.satnam>
	 <1246440977.3403.7.camel@hpdv5.satnam>
	 <1246441043.3403.9.camel@hpdv5.satnam>
	 <1246441094.3403.10.camel@hpdv5.satnam> <20090701112406.GE15958@elte.hu>
	 <1246622515.2322.30.camel@jaswinder.satnam> <20090704102230.GE2139@elte.hu>
	 <1246717039.2329.26.camel@jaswinder.satnam>
	 <20090705011123.GA31673@elte.hu> <1246768166.2325.8.camel@jaswinder.satnam>
	 <20090705080459.GA11636@elte.hu>
Content-Type: text/plain
Date: Sun, 05 Jul 2009 14:31:38 +0530
Message-Id: <1246784498.2467.10.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-07-05 at 10:04 +0200, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 

> I'm simply not going to apply patches from you for what i consider a 
> half-done feature.
> 

This is not half-done. There are only 3 hardware interrupt performance
counter events in Intel and AMD. And I supported all of them.

I also supported all relevant Intel models and all AMD models.

You are requesting for software counter for hardirqs, I have no problem
to support it, I have also plan to add exceptions through software
counters, but again it will be different patch. And there is no point of
blocking this patch, as this will never change even if you add software
counters.

And you not even telling the problem in this patch, but you want to add
more stuff, which is independent of this.

So it is time to reconsider your consideration.

Thanks,
--
JSR


