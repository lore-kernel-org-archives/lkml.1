Return-Path: <linux-kernel-owner+w=401wt.eu-S1761344AbYILVBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761344AbYILVBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 17:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759471AbYILUuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 16:50:44 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:13004 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758207AbYILUum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 16:50:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=JbG6a3tBeBM59glslbs46idxtdag/BOBVMKblFIyI2omg9AJZDJz8Art8SvsUhsCOZ
         KJBHo4L9SVUc3S8rZI5QP2zn/XAipCaeyXtr+mNXPAQbq+NwgkpcDS96yrbKuGJN8kAE
         HLGlJTf4RbpZKuILvAchAm4SnxFLdWqLbM+NI=
Message-ID: <19f34abd0809121350m480ee4aak9786b8eb4064d50c@mail.gmail.com>
Date: Fri, 12 Sep 2008 22:50:42 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #11407] suspend: unable to handle kernel paging request
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Pavel Machek" <pavel@suse.cz>, "Pekka Enberg" <penberg@cs.helsinki.fi>
In-Reply-To: <SpS7rta8n4.A.0sH.PdsyIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik>
	 <SpS7rta8n4.A.0sH.PdsyIB@albercik>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2008 at 9:06 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=11407
> Subject         : suspend: unable to handle kernel paging request
> Submitter       : Vegard Nossum <vegard.nossum@gmail.com>
> Date            : 2008-08-21 17:28 (23 days old)
> References      : http://marc.info/?l=linux-kernel&m=121933974928881&w=4
> Handled-By      : Rafael J. Wysocki <rjw@sisk.pl>
>                  Pekka Enberg <penberg@cs.helsinki.fi>
>                  Pavel Machek <pavel@suse.cz>

I'm sorry for not replying sooner. This is current status: Problem was
never resolved. I tried to bisect, but I only ran into other problems
with either config not being supported for my machine prior to certain
date while trying to find a good bisection point. It's been a while
now, so I don't remember everything exactly, but I may try to
reproduce it tomorrow on the latest -git and see what comes up.

Will report back as soon as I have more info. Thanks,


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
