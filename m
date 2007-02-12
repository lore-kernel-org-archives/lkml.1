Return-Path: <linux-kernel-owner+w=401wt.eu-S1030456AbXBLXD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030456AbXBLXD4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 18:03:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030459AbXBLXD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 18:03:56 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030456AbXBLXDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 18:03:55 -0500
Message-ID: <45D0F27E.1020302@redhat.com>
Date: Mon, 12 Feb 2007 18:04:30 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86 for review III] [17/29] x86: Add new CPUID bits for
 AMD Family 10 CPUs in /proc/cpuinfo
References: <20070212551.664370000@suse.de> <20070212165137.AD85913E1B@wotan.suse.de> <45D0E60F.2090506@redhat.com> <200702122323.53364.andi@firstfloor.org> <45D0EC39.8030608@redhat.com> <20070212223814.GA16951@one.firstfloor.org>
In-Reply-To: <20070212223814.GA16951@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> A one-liner for each in the comments would be just enough.
> 
> No. RTFM.

Sure, I'll get right on that:

./AMD:
total 16216
-rw-rw-r-- 1 cebbert cebbert 2485489 Nov 22 13:49 24592.pdf
-rw-rw-r-- 1 cebbert cebbert 3537793 Nov 22 13:49 24593.pdf
-rw-rw-r-- 1 cebbert cebbert 2212151 Nov 22 13:49 24594.pdf
-rw-rw-r-- 1 cebbert cebbert 3474511 Nov 22 13:49 25112.pdf
-rw-rw-r-- 1 cebbert cebbert 1992762 Nov 22 13:49 26568.pdf
-rw-rw-r-- 1 cebbert cebbert 1558189 Nov 22 13:49 26569.pdf
-rw-rw-r-- 1 cebbert cebbert  616422 Nov 22 13:49 34434.pdf
-rw-rw-r-- 1 cebbert cebbert  646779 Nov 22 13:49 40555.pdf

./Intel:
total 17284
-rw-rw-r-- 1 cebbert cebbert 3199114 Nov  8 16:58 248966.pdf
-rw-rw-r-- 1 cebbert cebbert  585350 Oct 30 18:44 25204618.pdf
-rw-rw-r-- 1 cebbert cebbert 3311769 Nov 16 14:49 253665.pdf
-rw-rw-r-- 1 cebbert cebbert 2515357 Nov 16 14:49 253666.pdf
-rw-rw-r-- 1 cebbert cebbert 2093479 Nov 16 14:49 253667.pdf
-rw-rw-r-- 1 cebbert cebbert 3274186 Nov 16 14:49 253668.pdf
-rw-rw-r-- 1 cebbert cebbert 2645170 Nov 16 14:50 253669.pdf

:-)

