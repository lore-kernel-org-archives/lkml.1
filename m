Return-Path: <linux-kernel-owner+w=401wt.eu-S1754985AbYA2KBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985AbYA2KBx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 05:01:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbYA2KBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 05:01:43 -0500
Received: from relay2.sgi.com ([192.48.171.30]:41283 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751538AbYA2KBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 05:01:42 -0500
Date: Tue, 29 Jan 2008 04:01:30 -0600
From: Paul Jackson <pj@sgi.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, vatsa@linux.vnet.ibm.com,
       dhaval@linux.vnet.ibm.com, nickpiggin@yahoo.com.au,
       ebiederm@xmission.com, akpm@linux-foundation.org, sgrubb@redhat.com,
       rostedt@goodmis.org, ghaskins@novell.com, dmitry.adamushko@gmail.com,
       tong.n.li@intel.com, tglx@linutronix.de, menage@google.com,
       rientjes@google.com
Subject: Re: scheduler scalability - cgroups, cpusets and load-balancing
Message-Id: <20080129040130.7b2904b6.pj@sgi.com>
In-Reply-To: <1201600428.28547.87.camel@lappy>
References: <1201600428.28547.87.camel@lappy>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter wrote:
> Also the RT load-balance needs to become aware of such these sets, I
> think Paul J and Steven once talked about it, but can't quite remember
> where that ended

See further the thread:

  http://lkml.org/lkml/2007/10/22/400

(I don't remember where it ended up either; probably nowhere.
 I'm just passing on the link, before doing any reading or thinking.)

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
