Return-Path: <linux-kernel-owner+w=401wt.eu-S1754470AbZLBPRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470AbZLBPRz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 10:17:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753068AbZLBPRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 10:17:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:43775 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbZLBPRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 10:17:54 -0500
Subject: Re: [PATCH -v2 1/2] sched, cputime: cleanups related to
 task_times()
From: Peter Zijlstra <peterz@infradead.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Spencer Candland <spencer@bluehost.com>,
       =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Oleg Nesterov <oleg@redhat.com>, Balbir Singh <balbir@in.ibm.com>
In-Reply-To: <4B1624C7.7040302@jp.fujitsu.com>
References: <4AFB9029.9000208@jp.fujitsu.com>
	 <20091112144919.GA6218@dhcp-lab-161.englab.brq.redhat.com>
	 <1258038038.4039.467.camel@laptop>
	 <20091112154050.GC6218@dhcp-lab-161.englab.brq.redhat.com>
	 <4B01A8DB.6090002@bluehost.com>
	 <20091117130851.GA3842@dhcp-lab-161.englab.brq.redhat.com>
	 <1258464288.7816.305.camel@laptop>
	 <20091119181744.GA3743@dhcp-lab-161.englab.brq.redhat.com>
	 <4B05F835.10401@jp.fujitsu.com>
	 <20091123100925.GB25978@dhcp-lab-161.englab.brq.redhat.com>
	 <20091123101612.GC25978@dhcp-lab-161.englab.brq.redhat.com>
	 <4B1624C7.7040302@jp.fujitsu.com>
Content-Type: text/plain
Date: Wed, 02 Dec 2009 16:17:35 +0100
Message-ID: <1259767055.4003.1037.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Could you, in the future, please start a new thread for new patches?

