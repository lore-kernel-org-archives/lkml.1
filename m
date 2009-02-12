Return-Path: <linux-kernel-owner+w=401wt.eu-S1757587AbZBLDWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587AbZBLDWq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 22:22:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756573AbZBLDWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 22:22:38 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:44478 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756529AbZBLDWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 22:22:37 -0500
Date: Wed, 11 Feb 2009 22:22:34 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
cc: "Luck, Tony" <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Mike Travis <travis@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "isimatu.yasuaki@jp.fujitsu.com" <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [PATCH 0/8] git pull request for tip/tracing/core
In-Reply-To: <49939457.7030001@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0902112222060.13954@gandalf.stny.rr.com>
References: <20090208054955.777429253@goodmis.org> <20090209093751.GD7930@elte.hu> <20090211153650.GA19576@elte.hu> <alpine.DEB.1.10.0902111147450.15438@gandalf.stny.rr.com> <alpine.DEB.1.10.0902111158380.15438@gandalf.stny.rr.com> <20090211171622.GA13239@elte.hu>
 <alpine.DEB.1.10.0902111227570.15438@gandalf.stny.rr.com> <20090211173131.GA27546@elte.hu> <57C9024A16AD2D4C97DC78E552063EA361689C3B@orsmsx505.amr.corp.intel.com> <49938BE6.1000402@jp.fujitsu.com> <alpine.DEB.1.10.0902112142050.13954@gandalf.stny.rr.com>
 <49939457.7030001@jp.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 12 Feb 2009, Kenji Kaneshige wrote:
> 
> Itanium processor has 240 vectors for external interrupts and
> has a mechanism to classifies them to 16 priority classes. The
> ia64 linux limits maximum nested interrupts depth to 16 using
> this mechanism.

Then 1000, should be more than enough ;-)

Thanks for the info,

-- Steve

