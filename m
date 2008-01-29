Return-Path: <linux-kernel-owner+w=401wt.eu-S1758064AbYA2MxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064AbYA2MxI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 07:53:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754521AbYA2Mwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 07:52:55 -0500
Received: from relay1.sgi.com ([192.48.171.29]:44327 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754520AbYA2Mwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 07:52:54 -0500
Date: Tue, 29 Jan 2008 06:52:46 -0600
From: Paul Jackson <pj@sgi.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, vatsa@linux.vnet.ibm.com,
       dhaval@linux.vnet.ibm.com, nickpiggin@yahoo.com.au,
       ebiederm@xmission.com, akpm@linux-foundation.org, sgrubb@redhat.com,
       rostedt@goodmis.org, ghaskins@novell.com, dmitry.adamushko@gmail.com,
       tong.n.li@intel.com, tglx@linutronix.de, menage@google.com,
       rientjes@google.com
Subject: Re: scheduler scalability - cgroups, cpusets and load-balancing
Message-Id: <20080129065246.6e99fb16.pj@sgi.com>
In-Reply-To: <1201609804.28547.137.camel@lappy>
References: <1201600428.28547.87.camel@lappy>
	<20080129040130.7b2904b6.pj@sgi.com>
	<1201603816.28547.94.camel@lappy>
	<20080129051353.4628c9eb.pj@sgi.com>
	<1201606284.28547.114.camel@lappy>
	<20080129060355.7d38338f.pj@sgi.com>
	<1201609804.28547.137.camel@lappy>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ok, I'll take a stab at understanding that code.

See also the section:

  1.7 What is sched_load_balance ?

in Documentation/cpusets.txt.

Good luck ;).

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
