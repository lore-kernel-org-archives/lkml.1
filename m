Return-Path: <linux-kernel-owner+w=401wt.eu-S965606AbXCQOdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965606AbXCQOdc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 10:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965565AbXCQOdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 10:33:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965606AbXCQOdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 10:33:31 -0400
Message-ID: <45FBFC18.8060700@redhat.com>
Date: Sat, 17 Mar 2007 10:32:56 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Con Kolivas <kernel@kolivas.org>, ck@vds.kolivas.org,
       Ingo Molnar <mingo@elte.hu>, Al Boldi <a1426z@gawab.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: RSDL v0.31
References: <200703042335.26785.a1426z@gawab.com>	 <200703170040.48316.kernel@kolivas.org>	 <1174059299.7886.25.camel@Homer.simpson.net>	 <200703170813.32594.kernel@kolivas.org> <1174084207.7009.9.camel@Homer.simpson.net>
In-Reply-To: <1174084207.7009.9.camel@Homer.simpson.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith wrote:

> If this is your final answer to the problem space, I am done testing,
> and as far as _I_ am concerned, your scheduler is an utter failure.

The increased AIM7 throughput (and the other benchmark results)
looked very promising to me.

I wonder what we're doing wrong in the normal scheduler...

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
