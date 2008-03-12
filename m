Return-Path: <linux-kernel-owner+w=401wt.eu-S1752078AbYCLMIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbYCLMIj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 08:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751327AbYCLMIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 08:08:31 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:51300 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbYCLMIa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 08:08:30 -0400
From: Chr <chunkeey@web.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Jike Song" <albcamus@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Brown, Len" <len.brown@intel.com>
Subject: Re: 2.6.25-rc5-git2: Reported regressions from 2.6.24
Date: Wed, 12 Mar 2008 13:08:26 +0100
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
References: <200803120141.51844.rjw@sisk.pl>
In-Reply-To: <200803120141.51844.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803121308.27662.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX19DZDGUIRevPLMCAeT8ffslhs17LXlb5cylOhV1
	IQZXz4rqmybU2zKSQy2cZgiShxescd3gCiOknVwuFvSC5L/+uW
	MFZ/SguL8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 March 2008 01:41:51 Rafael J. Wysocki wrote:
>
> This message contains a list of some regressions from 2.6.24 reported since
> 2.6.25-rc1 was released, for which there are no fixes in the mainline I
> know of.  If any of them have been fixed already, please let me know.
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10228
> Subject		: endless loop in native_flush_tlb_others in smp_64.c
> Submitter	: Chr <chunkeey@web.de>
> Date		: 2008-03-10 23:16 (3 days old)
> References	: http://lkml.org/lkml/2008/3/10/333
> Handled-By	: Thomas Gleixner <tglx@linutronix.de>
>
My bug report is a "dup" from that one:

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10207
Subject		: INFO: task mount:11202 blocked for more than 120 seconds
Submitter	: Christian Kujau <lists@nerdbynature.de>
Date		: 2008-03-07 21:32 (6 days old)
References	: http://lkml.org/lkml/2008/3/7/308
		  http://lkml.org/lkml/2008/3/9/186
Handled-By	: David Chinner <dgc@sgi.com>

Thanks,
	Chr

