Return-Path: <linux-kernel-owner+w=401wt.eu-S932703AbZGPQUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932703AbZGPQUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 12:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932684AbZGPQUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 12:20:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42657 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932683AbZGPQUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 12:20:53 -0400
Message-ID: <4A5F5326.8060307@zytor.com>
Date: Thu, 16 Jul 2009 12:19:50 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Masami Hiramatsu <mhiramat@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andi Kleen <ak@linux.intel.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, Avi Kivity <avi@redhat.com>,
       =?UTF-8?B?UHJ6ZW15c8WCYXdQYXdlxYJjenlr?= <przemyslaw@pawelczyk.it>
Subject: Re: [PATCH -tip -v12 01/11] x86: instruction decoder API
References: <20090716155652.6266.39970.stgit@localhost.localdomain> <20090716155700.6266.71011.stgit@localhost.localdomain>
In-Reply-To: <20090716155700.6266.71011.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
> 
> These opcode maps do NOT include most of SSE and FP opcodes, because
> those opcodes are not used in the kernel.
> 

That is not true.

	-hpa
