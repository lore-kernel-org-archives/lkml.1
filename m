Return-Path: <linux-kernel-owner+w=401wt.eu-S1759350AbYBMUjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759350AbYBMUjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 15:39:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751145AbYBMUi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 15:38:57 -0500
Received: from homer.mvista.com ([63.81.120.158]:5290 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbYBMUi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 15:38:56 -0500
Message-ID: <47B35558.9030709@ct.jp.nec.com>
Date: Wed, 13 Feb 2008 12:38:48 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, a.p.zijlstra@chello.nl
Subject: Re: [RFC v2 PATCH] RTTIME watchdog timer proc interface
References: <47B220A6.5090707@ct.jp.nec.com>	<20080213011310.e27dd9cf.akpm@linux-foundation.org>	<47B32CD2.3040200@ct.jp.nec.com> <20080213113907.5aec8ba3.akpm@linux-foundation.org>
In-Reply-To: <20080213113907.5aec8ba3.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 13 Feb 2008 09:45:54 -0800
> Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:
> 
>>>> And /proc/<pid>/task/<tid>/rttime is also accessible.
>>> Please describe the format in the changelog.
>> I'm sorry I cannot catch your meaning.
> 
> Please include an example of the output of
> `cat /proc/<pid>/task/<tid>/rttime' in the changelog so that we
> can see precisely what interface you are proposing.

thanks, I see.

