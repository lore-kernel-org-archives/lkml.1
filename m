Return-Path: <linux-kernel-owner+w=401wt.eu-S1761625AbYCCKBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761625AbYCCKBr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 05:01:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756391AbYCCKB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 05:01:27 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:43903 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671AbYCCKB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 05:01:26 -0500
Message-ID: <47CBCC01.6080504@linux.vnet.ibm.com>
Date: Mon, 03 Mar 2008 15:29:29 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: serge@hallyn.com, Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.osdl.org, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, xemul@openvz.org, pj@sgi.com
Subject: Re: [RFC] Prefixing cgroup generic control filenames with "cgroup."
References: <6599ad830802281314s25c033d6tc021725ae28aef8d@mail.gmail.com> <20080228132142.4d4b1eef.akpm@linux-foundation.org> <6599ad830802281328q162d0585v3ac6b45a119a4a05@mail.gmail.com> <20080228213319.GC1232@vino.hallyn.com> <6599ad830802281406s512ee32bkeb2b0387a7737a87@mail.gmail.com> <6599ad830803030038p2d81883bu895260a96fedaec6@mail.gmail.com>
In-Reply-To: <6599ad830803030038p2d81883bu895260a96fedaec6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Thu, Feb 28, 2008 at 2:06 PM, Paul Menage <menage@google.com> wrote:
>> On Thu, Feb 28, 2008 at 1:33 PM,  <serge@hallyn.com> wrote:
>>  >
>>  >  You said the set of files belong to cgroup itself is likely to increase
>>  >  - do you have some candidates in mind?
>>
>>  Nothing concrete right now. One example that I already proposed was
>>  the "cgroup.api" file but that's shelved for now, until such time as I
>>  actually propose the binary API that it was intended to help support.
>>
> 
> One likely new file that people agreed a while ago could be useful
> would be a "procs" file, similar to "tasks", but acting (and
> reporting) on thread groups rather than individual tasks.
> 
> Paul

Yes, I remember this. This feature would be extremely useful.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
