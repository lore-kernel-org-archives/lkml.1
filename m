Return-Path: <linux-kernel-owner+w=401wt.eu-S935189AbZJORV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935189AbZJORV3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 13:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757518AbZJORV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 13:21:28 -0400
Received: from lucidpixels.com ([75.144.35.66]:44818 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754706AbZJORV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 13:21:28 -0400
Date: Thu, 15 Oct 2009 13:20:51 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: "Allan, Bruce W" <bruce.w.allan@intel.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Linux* is not supported on the Intel(R) Desktop Board DP55KG -
 Kernel still hangs upon reboot.
In-Reply-To: <8DD2590731AB5D4C9DBF71A877482A903AF66FAB@orsmsx509.amr.corp.intel.com>
Message-ID: <alpine.DEB.2.00.0910151319390.22270@p34.internal.lan>
References: <alpine.DEB.2.00.0910151226000.10075@p34.internal.lan> <8DD2590731AB5D4C9DBF71A877482A903AF66FAB@orsmsx509.amr.corp.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bruce,

Thank you.

Yes, I am running the latest BIOS available on Intel's site:

KG3822P.BIO (9/25/2009) Status: Latest

Justin.

On Thu, 15 Oct 2009, Allan, Bruce W wrote:

> I am not aware of any workaround for the reboot problem on that particular board and do not have one of the boards myself.  I've forwarded the issue on to a list of people who may be able to help.  In the meantime have you tried re-flashing with the latest BIOS?
>
>> -----Original Message-----
>> From: Justin Piszcz [mailto:jpiszcz@lucidpixels.com]
>> Sent: Thursday, October 15, 2009 9:29 AM
>> To: linux-kernel@vger.kernel.org
>> Cc: Allan, Bruce W
>> Subject: Linux* is not supported on the Intel(R) Desktop Board DP55KG -
>> Kernel still hangs upon reboot.
>>
>> Hello,
>>
>> Bruce, it looks like that is coming from here:
>> http://www.intel.com/support/motherboards/desktop/sb/CS-008326.htm
>>
>> Is there any workaround for the reboot problem?
>> http://www.gossamer-
>> threads.com/lists/linux/kernel/1141848?do=post_view_threaded
>>
>> It looks like there was a similar bug on 965 motherboards, in which, Intel
>> issued a BIOS update that fixed it:
>> http://lkml.indiana.edu/hypermail/linux/kernel/0610.2/2215.html
>>
>> Is Intel aware of this-- is there any communication/channels a customer
>> can utilize (besides LKML) to ask Intel about the status/ETA on a fix for
>> this issue?
>>
>> Justin.
>
