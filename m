Return-Path: <linux-kernel-owner+w=401wt.eu-S1760265AbZAOQES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760265AbZAOQES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 11:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755280AbZAOQD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 11:03:57 -0500
Received: from squawk.glines.org ([72.36.206.66]:37274 "EHLO squawk.glines.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755177AbZAOQD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 11:03:56 -0500
Message-ID: <496F5DA0.3060001@glines.org>
Date: Thu, 15 Jan 2009 08:00:32 -0800
From: Mark Glines <mark@glines.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090112)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: L-K <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.28 has unconfigurable group sched?
References: <496CDDE9.3050008@glines.org> <1231926992.7141.23.camel@twins>	 <496DFACE.10403@glines.org> <1232004544.14825.75.camel@laptop>
In-Reply-To: <1232004544.14825.75.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Wed, 2009-01-14 at 06:46 -0800, Mark Glines wrote:
>> Thanks.  Sadly, this doesn't seem to change anything for me.  I applied
>> it to 2.6.28, rebuilt and reinstalled, and got the same result.  I did a
>> clean rebuild to be sure; and got the same behavior again.

> Most strange, I did the patch on .28 just to be sure (my initial testing
> was done on -linus since I couldn't remember it having changed in a
> while), and it still works for me.

No, I'm sorry, you're right.  It does work beautifully now with your
patch.  I just hadn't been testing the correct kernel image (oops).

Thanks!

Mark
