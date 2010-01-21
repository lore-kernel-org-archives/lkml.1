Return-Path: <linux-kernel-owner+w=401wt.eu-S1751582Ab0AUPgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582Ab0AUPgv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 10:36:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187Ab0AUPgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 10:36:51 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43834 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab0AUPgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 10:36:50 -0500
Subject: Re: [PATCH] sched: cpuacct: Use bigger percpu counter batch values
 for stats counters
From: Peter Zijlstra <peterz@infradead.org>
To: balbir@linux.vnet.ibm.com
Cc: Anton Blanchard <anton@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, balajirrao@gmail.com,
       dhaval@linux.vnet.ibm.com, tglx@linutronix.de,
       kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org,
       Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com
In-Reply-To: <4B5871F3.5020800@linux.vnet.ibm.com>
References: <20090512102412.GG6351@balbir.in.ibm.com>
	 <20090512102939.GB11714@elte.hu>
	 <20090512193656.D647.A69D9226@jp.fujitsu.com>
	 <20090716081010.GB3134@in.ibm.com> <20090716083948.GA2950@kryten>
	 <20090820051038.GF21100@kryten> <20100118044142.GS12666@kryten>
	 <20100118104213.64231c1e@mschwide.boeblingen.de.ibm.com>
	 <20100118095527.GV12666@kryten>  <4B5871F3.5020800@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Jan 2010 16:36:19 +0100
Message-ID: <1264088179.4283.1173.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-21 at 20:55 +0530, Balbir Singh wrote:

> Could we please pick up the patch for -tip?

OK, will queue it up if Ingo doesn't beat me to it.

