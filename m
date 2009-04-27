Return-Path: <linux-kernel-owner+w=401wt.eu-S1756203AbZD0Ovl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203AbZD0Ovl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 10:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932141AbZD0OsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 10:48:17 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:59564 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932133AbZD0OsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 10:48:14 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 27 Apr 2009 07:44:13 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Steven Rostedt <rostedt@goodmis.org>
cc: Andi Kleen <ak@linux.intel.com>, Huang Ying <ying.huang@intel.com>,
       Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: Re-implement MCE log ring buffer as per-CPU ring buffer
In-Reply-To: <alpine.DEB.2.00.0904271027580.24293@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.1.10.0904270738470.9296@makko.or.mcafeemobile.com>
References: <1240391484.6842.474.camel@yhuang-dev.sh.intel.com>  <20090422092259.GC18226@elte.hu> <20090422101600.GL3226@erda.amd.com>  <1240553210.6842.871.camel@yhuang-dev.sh.intel.com>  <20090424100943.GJ27264@erda.amd.com> 
 <alpine.DEB.2.00.0904240935140.24293@gandalf.stny.rr.com> <1240818596.6842.1001.camel@yhuang-dev.sh.intel.com> <49F5646F.4000305@linux.intel.com> <alpine.DEB.2.00.0904271027580.24293@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Apr 2009, Steven Rostedt wrote:

> Once it is filed then I can post it, I do not need to wait till it is 
> done.
> 
> And what the hell do you mean about not using patents?? We have several 
> patents in the kernel. Have you ever heard of the Open Invention Network?
> 
>  http://www.openinventionnetwork.com/
> 
> This patent will go under the Open Source patent pool to help 
> protect against patent attacks against Linux, et. al.
> 
> Yes, the Open Source community can file their own patents. The more 
> patents owned by the Open Source community, the better.

IANAL, but what is the point of it? If that's for OSS IP protection 
against Evil Corporate claims, isn't the only fact that you posted the 
code and algorirthm, constitutes Prior Art, that would automatically 
protect your contribution from future claims?


- Davide


