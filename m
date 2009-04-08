Return-Path: <linux-kernel-owner+w=401wt.eu-S1755484AbZDHWvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbZDHWvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 18:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754175AbZDHWvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 18:51:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:28929 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753666AbZDHWvg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 18:51:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,157,1239001200"; 
   d="scan'208";a="446296470"
From: "Luck, Tony" <tony.luck@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       Jason Baron <jbaron@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>, Michael Davidson <md@google.com>
Date: Wed, 8 Apr 2009 15:51:32 -0700
Subject: RE: [PATCH] tracing/syscalls: use a dedicated file header
Thread-Topic: [PATCH] tracing/syscalls: use a dedicated file header
Thread-Index: Acm4m46mDkCIULKaTgm7bK3bS/FMigAACZwA
Message-ID: <57C9024A16AD2D4C97DC78E552063EA39B2F739D@orsmsx505.amr.corp.intel.com>
References: <1236955332-10133-1-git-send-email-fweisbec@gmail.com>
 <1236955332-10133-2-git-send-email-fweisbec@gmail.com>
 <12c511ca0904061455k3f8a9cc8r25b7930f257ed922@mail.gmail.com>
 <20090408184058.GB6017@nowhere>
 <57C9024A16AD2D4C97DC78E552063EA39B2F707D@orsmsx505.amr.corp.intel.com>
 <alpine.DEB.2.00.0904081842500.12259@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0904081842500.12259@gandalf.stny.rr.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Great! I'll pull it into my repo and get it ready to send to tip.
>
> Is it OK to add a:
>
> Reported-Tested-and-Acked-by: Tony Luck <tony.luck@intel.com>

Maybe that will give the scripts that parse "git log" output
some grief as I don't see that tag ever used before.  I do
see a few (4) "Tested-and-Acked-by", so you could add:

Reported-by: Tony Luck <tony.luck@intel.com>
Tested-and-Acked-by: Tony Luck <tony.luck@intel.com>

-Tony
