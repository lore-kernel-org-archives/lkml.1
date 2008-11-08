Return-Path: <linux-kernel-owner+w=401wt.eu-S1752575AbYKHCyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbYKHCyu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 21:54:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbYKHCy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 21:54:29 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38282 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbYKHCy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 21:54:28 -0500
Message-ID: <4914FF18.5020805@redhat.com>
Date: Fri, 07 Nov 2008 21:53:12 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, David Miller <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>, maneesh@in.ibm.com,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Srinivasa Ds <srinivasa@in.ibm.com>
Subject: Re: [PATCH] kprobe: increase kprobe_hash_table size
References: <4914D2DE.9030603@redhat.com>	<20081107155646.b375413e.akpm@linux-foundation.org>	<4914DAEE.2050301@redhat.com>	<20081107170307.1a4f815e.akpm@linux-foundation.org>	<4914FA8D.4000607@redhat.com> <20081107184629.97eb5ec3.akpm@linux-foundation.org> <4914FE6C.5060504@redhat.com>
In-Reply-To: <4914FE6C.5060504@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
> Andrew Morton wrote:
>> On Fri, 07 Nov 2008 21:33:49 -0500 Masami Hiramatsu <mhiramat@redhat.com> wrote:
>>
>>> Not really. Hmm, I have to investigate more on this problem.
>> OK ;)
>>
>> Meanwhile, how does this look?
> 
> Great! That is enough acceptable.

However, we still have to find reasonable way on SMP...

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

