Return-Path: <linux-kernel-owner+w=401wt.eu-S1754585AbZHYGWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbZHYGWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 02:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754296AbZHYGWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 02:22:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:57892 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693AbZHYGWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 02:22:34 -0400
Subject: Re: system gets stuck in a lock during boot
From: Peter Zijlstra <peterz@infradead.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Justin Mattock <justinmattock@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4A937EFA.5050706@cn.fujitsu.com>
References: <4A84345D.60506@gmail.com>
	 <alpine.DEB.2.00.0908181926410.28398@gandalf.stny.rr.com>
	 <4A8B4607.6090303@gmail.com> <4A8B5113.20102@cn.fujitsu.com>
	 <4A8FA2BD.4030707@gmail.com> <4A91FDED.9050801@cn.fujitsu.com>
	 <1251093523.7538.118.camel@twins> <4A922F82.9080000@cn.fujitsu.com>
	 <1251096925.7538.121.camel@twins> <4A9251EB.8040805@gmail.com>
	 <dd18b0c30908241219mdb76311t9334929f34f2c4c3@mail.gmail.com>
	 <1251179444.7538.977.camel@twins>  <4A937EFA.5050706@cn.fujitsu.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 25 Aug 2009 08:21:44 +0200
Message-Id: <1251181304.7538.1018.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-25 at 14:04 +0800, Li Zefan wrote:
> Peter Zijlstra wrote:
> > On Mon, 2009-08-24 at 12:19 -0700, Justin Mattock wrote:
> > 
> >> O.K. I feel better, deleted
> >> my system, and threw in a minimal built system
> >> with only the bare essentials to boot.
> >> (just to make sure things are correct).
> >>
> >> unfortunately after building rc6 I'm still hitting
> >> this. really am not sure why this is happening.
> > 
> > Could you share your .config so we could have a try?
> > 
> 
> Justin sent his config in an earlier mail in this thread.
> But Steven didn't reproduce the bug with the config,
> neither me.
> 
> And we don't receive another bug report regarding to this
> crash.

Right, weird story this..
