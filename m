Return-Path: <linux-kernel-owner+w=401wt.eu-S1757302AbYCUQJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302AbYCUQJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 12:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbYCUQIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 12:08:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:28526 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbYCUQIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 12:08:48 -0400
Message-ID: <47E3DD8C.4000904@colorfullife.com>
Date: Fri, 21 Mar 2008 17:08:44 +0100
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Nadia Derbey <Nadia.Derbey@bull.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Scalability requirements for sysv ipc
References: <47E382DB.70503@colorfullife.com> <47E3ADE3.4030304@bull.net> <47E3B924.3000304@colorfullife.com> <20080321141339.GB9618@linux.vnet.ibm.com>
In-Reply-To: <20080321141339.GB9618@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> I could give it a spin -- though I would need to be pointed to the
> patch and the test.
>
>   
I'd just compare a recent kernel with something older, pre Fri Oct 19 
11:53:44 2007

Then download ctxbench, run one instance on each core, bound with taskset.
http://www.tmr.com/%7Epublic/source/
(I don't juse ctxbench myself, if it doesn't work then I could post my 
own app. It would be i386 only with RDTSCs inside)

I'll try to run it on my PentiumIII/850, right now I'm still setting 
everything up.

--
    Manfred
