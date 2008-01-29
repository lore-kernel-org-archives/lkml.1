Return-Path: <linux-kernel-owner+w=401wt.eu-S1758378AbYA2MVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758378AbYA2MVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 07:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbYA2MVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 07:21:11 -0500
Received: from relay1.sgi.com ([192.48.171.29]:49444 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752467AbYA2MVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 07:21:10 -0500
Date: Tue, 29 Jan 2008 06:21:04 -0600
From: Paul Jackson <pj@sgi.com>
To: vatsa@linux.vnet.ibm.com
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org, mingo@elte.hu,
       dhaval@linux.vnet.ibm.com, nickpiggin@yahoo.com.au,
       ebiederm@xmission.com, akpm@linux-foundation.org, sgrubb@redhat.com,
       rostedt@goodmis.org, ghaskins@novell.com, dmitry.adamushko@gmail.com,
       tong.n.li@intel.com, tglx@linutronix.de, menage@google.com,
       rientjes@google.com
Subject: Re: scheduler scalability - cgroups, cpusets and load-balancing
Message-Id: <20080129062104.7237b3c6.pj@sgi.com>
In-Reply-To: <20080129123223.GM1044@linux.vnet.ibm.com>
References: <1201600428.28547.87.camel@lappy>
	<1201604243.28547.101.camel@lappy>
	<20080129123223.GM1044@linux.vnet.ibm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vatsa wrote to Peter:
> After reading your explanation in the other mail abt what you mean here,
> I agree.

Ah good - glad someone understood that.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
