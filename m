Return-Path: <linux-kernel-owner+w=401wt.eu-S1756158AbYGMThQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbYGMThQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 15:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952AbYGMThD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 15:37:03 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:43878 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542AbYGMThA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 15:37:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=MuyTqC5rc8Uj+vW8j6bQyHrqMz0AzCZ/61ylOZ4bcNtIikYoNBS2vYb5S+j0gSKrJx
         w5/zk0pHXcvV4p89t9reyKwr6Qan5kPswevzTvsa2r0QQ9R/RDRi44VmT0YcIZy5JhsU
         E9/r0lAeh8vmTdHkbNvPHD9zx0HayO0d6Sbbk=
Message-ID: <19f34abd0807131237s1494b532s577da1a208b71c2d@mail.gmail.com>
Date: Sun, 13 Jul 2008 21:37:00 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #10955] v2.6.26-rc7: BUG task_struct: Poison overwritten
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <c6ZRbn0adb.A.zd.EIleIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Y1jK9GMA8kJ.A.qOH.7GleIB@albercik>
	 <c6ZRbn0adb.A.zd.EIleIB@albercik>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 13, 2008 at 8:00 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10955
> Subject         : v2.6.26-rc7: BUG task_struct: Poison overwritten
> Submitter       : Vegard Nossum <vegard.nossum@gmail.com>
> Date            : 2008-06-21 19:24 (23 days old)
> References      : http://marc.info/?l=linux-kernel&m=121407641925121&w=4
> Handled-By      : Peter Zijlstra <a.p.zijlstra@chello.nl>

Oh, wait, this probably wasn't a regression in the first place. It's
probably just obscure and rare enough that it was never discovered
earlier.

I'm in favour of closing this and reopening if it reappears. Or if you
simply just want to take it out of the regression list, that's also
fine with me.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
