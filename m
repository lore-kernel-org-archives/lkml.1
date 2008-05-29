Return-Path: <linux-kernel-owner+w=401wt.eu-S1759443AbYE2X2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759443AbYE2X2n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 19:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754930AbYE2X2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 19:28:36 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:38634 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754390AbYE2X2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 19:28:35 -0400
Message-ID: <483F3C27.40508@linux.vnet.ibm.com>
Date: Thu, 29 May 2008 18:28:39 -0500
From: Jon Tollefson <kniht@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Martin Bligh <mbligh@mbligh.org>
CC: "Randy.Dunlap" <rdunlap@xenotime.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Theodore Tso <tytso@mit.edu>, Hugh Dickins <hugh@veritas.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       bugme-admin@linux-foundation.org
Subject: Re: [Bug #10732] REGRESSION: 2.6.26-rc2-git4: X server failed start
 on X61s laptop
References: <1NnHL0AVfcI.A.hJC.ZdIOIB@albercik> <20080526192247.GA7515@mit.edu>  <20080527125426.GJ7515@mit.edu> <200805292254.55248.rjw@sisk.pl> <Pine.LNX.4.64.0805291414340.16189@shark.he.net> <8f3aa8d60805291454s280a28d1g6c3891276c69a69e@mail.gmail.com>
In-Reply-To: <8f3aa8d60805291454s280a28d1g6c3891276c69a69e@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Bligh wrote:
> On Thu, May 29, 2008 at 2:15 PM, Randy.Dunlap <rdunlap@xenotime.net> wrote:
>   
>> On Thu, 29 May 2008, Rafael J. Wysocki wrote:
>>
>>     
>>> On Tuesday, 27 of May 2008, Theodore Tso wrote:
>>>       
>>>> Bug #10732 is now closed.  BTW, it seems d*mned strange that the
>>>> submitter of the bug doesn't have the power to close a bug without
>>>> first grabbing the bug as the bug-fixer, changing its state to
>>>> ASSIGNED, and *then* being allowed to close the bug.  Grumble,
>>>> bugzilla's !#@#?@ process straightjacket....
>>>>         
>>> That depends on your account's access rights within the Bugzilla, which always
>>> have been a mystery to me.
>>>       
>> Martin Bligh should be able to clear that mystery up.
>>     
>
> Jon ... is that something we can configure? Seems ... wrong.
> Submitter and owner should both have power to edit the bug.
>   
Submitter and owner should be able to edit the bug as far I as can see.

If the bug is not already in the resolved state then you can use the
Close check box at the end of the 'Resolve' option line to close a bug
with one submit.  You do not have to change it to the assign state in
order to close it either - if it is the submitter or owner that is
closing it.  These statements do not apply to bugzilla in general but do
apply to the bugzilla.kernel.org one.

Jon

