Return-Path: <linux-kernel-owner+w=401wt.eu-S1752678AbXCQOnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678AbXCQOnm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 10:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbXCQOnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 10:43:42 -0400
Received: from mail.gmx.net ([213.165.64.20]:45192 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752678AbXCQOnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 10:43:41 -0400
X-Provags-ID: V01U2FsdGVkX19VZ3hIK7xVg7bsckPBXZLIItH3V89odU/fAHZFyL
	QI3gjjlnrzmqWp
Subject: Re: RSDL v0.31
From: Mike Galbraith <efault@gmx.de>
To: Rik van Riel <riel@redhat.com>
Cc: Con Kolivas <kernel@kolivas.org>, ck@vds.kolivas.org,
       Ingo Molnar <mingo@elte.hu>, Al Boldi <a1426z@gawab.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <45FBFC18.8060700@redhat.com>
References: <200703042335.26785.a1426z@gawab.com>
	 <200703170040.48316.kernel@kolivas.org>
	 <1174059299.7886.25.camel@Homer.simpson.net>
	 <200703170813.32594.kernel@kolivas.org>
	 <1174084207.7009.9.camel@Homer.simpson.net>  <45FBFC18.8060700@redhat.com>
Content-Type: text/plain
Date: Sat, 17 Mar 2007 15:43:29 +0100
Message-Id: <1174142609.7614.18.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-03-17 at 10:32 -0400, Rik van Riel wrote:
> Mike Galbraith wrote:
> 
> > If this is your final answer to the problem space, I am done testing,
> > and as far as _I_ am concerned, your scheduler is an utter failure.
> 
> The increased AIM7 throughput (and the other benchmark results)
> looked very promising to me.
> 
> I wonder what we're doing wrong in the normal scheduler...

Yeah, I tried AIM7 with both schedulers, but apparently you need size
mondo hardware.  My poor little box produced identical results.

(I only noticed one other benchmark result, and IIRC it showed a ~5%
drop in throughput, which was attributed to higher context switch rate)

	-Mike

