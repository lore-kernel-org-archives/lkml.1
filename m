Return-Path: <linux-kernel-owner+w=401wt.eu-S933331AbZJGNBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933331AbZJGNBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 09:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933136AbZJGNBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 09:01:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:53924 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933132AbZJGNBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 09:01:17 -0400
Subject: Re: system gets stuck in a lock during boot
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4ACC001D.4050105@gmail.com>
References: <1251096925.7538.121.camel@twins> <4A9251EB.8040805@gmail.com>
	 <dd18b0c30908241219mdb76311t9334929f34f2c4c3@mail.gmail.com>
	 <20090825085919.GB14003@elte.hu> <4A94803A.5060408@gmail.com>
	 <20090826073351.GE23435@elte.hu> <4A9549E5.5020002@gmail.com>
	 <dd18b0c30909071449q6834e847yb0f27ec971c9564a@mail.gmail.com>
	 <20091002211211.GA2633@redhat.com>
	 <1254792249.13160.213.camel@gandalf.stny.rr.com>
	 <20091006203225.GC2631@redhat.com>
	 <1254880921.1696.112.camel@gandalf.stny.rr.com>
	 <4ACC001D.4050105@gmail.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 07 Oct 2009 09:00:29 -0400
Message-Id: <1254920429.1696.127.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-06 at 19:42 -0700, Justin P. Mattock wrote:

> >    
> o.k. applied your patch, but unfortunantly
> I still am hitting this kernel panic.
> 
> must admit I have no idea why this is doing this.
> (but am willing to sit through this, because eventually
> sooner or later will hit this if I update gcc).

But the panic you showed was that it could not find an init to execute.
Which looks like a setup issue and not a kernel bug.

-- Steve


