Return-Path: <linux-kernel-owner+w=401wt.eu-S1756684AbYCaKOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684AbYCaKOw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 06:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754233AbYCaKOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 06:14:46 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:53738 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121AbYCaKOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 06:14:45 -0400
Message-ID: <47F0B98E.6090107@linux.vnet.ibm.com>
Date: Mon, 31 Mar 2008 15:44:38 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pawel Staszewski <pstaszewski@artcom.pl>,
       Christoph Lameter <clameter@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc7-git2: Reported regressions from 2.6.24
References: <200803272353.51901.rjw@sisk.pl> <alpine.LFD.1.00.0803271859280.14670@woody.linux-foundation.org> <86802c440803272031o2d3c1d3aw4f03e60883a8716e@mail.gmail.com>
In-Reply-To: <86802c440803272031o2d3c1d3aw4f03e60883a8716e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Thu, Mar 27, 2008 at 7:30 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>>  On Thu, 27 Mar 2008, Rafael J. Wysocki wrote:
>>  >
> ...
>>  > Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=9962
>>  > Subject               : mount: could not find filesystem
>>  > Submitter     : Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
>>  > Date          : 2008-02-12 14:34 (45 days old)
>>  > References    : http://lkml.org/lkml/2008/2/12/91
>>  > Handled-By    : Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>>  >                 Yinghai Lu <yhlu.kernel@gmail.com>
>>
>>  Needs more info. The original oops that opened it is fixed, but..
>>
> Kamalesh,
> can you check that?
> 
> YH
Hi,

I have tested the 2.6.25-rc7 kernel and the kernel boots up without the panic.

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
