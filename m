Return-Path: <linux-kernel-owner+w=401wt.eu-S1754205AbZGWNJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbZGWNJt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 09:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754034AbZGWNJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 09:09:48 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:15303 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbZGWNJr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 09:09:47 -0400
X-SpamScore: -5
X-BigFish: VPS-5(zz140fM1442Jzz1202hzzz32i6bh1f9i67h)
X-Spam-TCS-SCL: 6:0
X-WSS-ID: 0KN8K9L-02-16X-01
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH][KVM][retry 4] Add support for Pause Filtering to AMD SVM
Date: Wed, 22 Jul 2009 17:40:48 -0500
Message-ID: <6453C3CB8E2B3646B0D020C112613273036209FB@sausexmb4.amd.com>
In-Reply-To: <200907090950.06204.sheng@linux.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH][KVM][retry 4] Add support for Pause Filtering to AMD SVM
Thread-Index: AcoAN5DdI+0qECmpTsOh2vJXjZz60wK5aszg
References: <200905050909.58583.mark.langsdorf@amd.com> <200907081319.57307.sheng@linux.intel.com> <6453C3CB8E2B3646B0D020C112613273036209F0@sausexmb4.amd.com> <200907090950.06204.sheng@linux.intel.com>
From: "Langsdorf, Mark" <mark.langsdorf@amd.com>
To: "Sheng Yang" <sheng@linux.intel.com>
CC: "Roedel, Joerg" <Joerg.Roedel@amd.com>, <peterz@infradead.org>,
       "Ingo Molnar" <mingo@elte.hu>, <avi@redhat.com>, <kvm@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, "Edwin Zhai" <edwin.zhai@intel.com>
X-OriginalArrivalTime: 22 Jul 2009 22:40:49.0277 (UTC) FILETIME=[75DBB2D0:01CA0B1D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Um, I am afraid we have the different result... With your 
> scheduler patch, we got 1% more performance improvement
> in the quick test. Of course more tests are needed to
> find a better value of delay.

What was your test case?  How many runs did you do?
My results had a lot of variance in them.

> Do you have time to work on it recently?

I've been working with the former VI guys on some scheduler
improvements for Xen, and hope to get back to this some
next week.

-Mark Langsdorf
Operating System Research Center
AMD

