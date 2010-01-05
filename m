Return-Path: <linux-kernel-owner+w=401wt.eu-S1754047Ab0AEEW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab0AEEW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 23:22:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753900Ab0AEEW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 23:22:26 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:45141 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753879Ab0AEEW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 23:22:26 -0500
Message-ID: <4B42BE79.9090802@us.ibm.com>
Date: Mon, 04 Jan 2010 20:22:17 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] trace-view: Add trace-view python wrapper
References: <1262654682-20325-1-git-send-email-dvhltc@us.ibm.com> <1262661789.28171.692.camel@gandalf.stny.rr.com>
In-Reply-To: <1262661789.28171.692.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Mon, 2010-01-04 at 17:24 -0800, Darren Hart wrote:
>> The following patch series wraps the C trace-view-store for use with Python.
>>
>> Please pull the latest for-rostedt/trace-view git tree from:
>>
>>    git://git.kernel.org/pub/scm/linux/kernel/git/dvhart/trace-cmd.git for-rostedt/trace-view
>>
>>
>> (Apologies if this series arrives twice, I seem to be experiencing relay
>> issues).
> 
> Thanks, but you never pushed this up to kernel.org. I've applied them on
> a temp branch and they work after fixing some conflicts with commits I
> made.
> 
> If you want, I can just push that back out, but that will require you to
> do a rebase. But if I do another pull from you, I'll just have to
> resolve the conflicts again.
> 

I guess in on-going relay issues I missed the "git push". If you don't 
mind just sending them back to me I'll push your version to my 
kernal.org repo so you don't have to repeat the merge. Sorry about that.

The patches still haven't hit LKML from what I can tell...

Thanks,

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
