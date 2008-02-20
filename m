Return-Path: <linux-kernel-owner+w=401wt.eu-S1765814AbYBTPpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765814AbYBTPpn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 10:45:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765043AbYBTPoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 10:44:54 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50455 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764994AbYBTPow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 10:44:52 -0500
Message-ID: <47BC4A68.5050704@redhat.com>
Date: Wed, 20 Feb 2008 10:42:32 -0500
From: Steven Rostedt <srostedt@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: ftrace causing panics.
References: <20080219124222.GB13780@linux.vnet.ibm.com> <20080219140352.GB9965@elte.hu> <20080219155433.GA4754@linux.vnet.ibm.com> <20080219161608.GA1347@elte.hu> <20080219173839.GF4754@linux.vnet.ibm.com> <47BC40FA.6020205@redhat.com> <20080220152815.GB1082@linux.vnet.ibm.com>
In-Reply-To: <20080220152815.GB1082@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dhaval Giani wrote:

> sched-devel as of yesterday. (I don't think anything new has gone in
> today).

I just sent Ingo my fixes a few minutes ago. You may want to keep an I 
out on updates to sched-devel.

> 
> [sorry, not had enough time to get to the bottom of this the last few
> days]
> 

No prob.

-- Steve
