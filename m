Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057AbZGEJ4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbZGEJ4y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 05:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753672AbZGEJ4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 05:56:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:51958 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365AbZGEJ4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 05:56:46 -0400
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
Date: Sun, 05 Jul 2009 15:25:40 +0530
Message-Id: <1246787740.2467.13.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-07-05 at 10:04 +0200, Ingo Molnar wrote:

> I'm simply not going to apply patches from you for what i consider a 
> half-done feature.
> 

OK, can you suggest me how output will look like so that I can start
preparing the hardirq patch.

Thanks,
--
JSR

