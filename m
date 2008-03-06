Return-Path: <linux-kernel-owner+w=401wt.eu-S1762825AbYCFK1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762825AbYCFK1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 05:27:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755948AbYCFK10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 05:27:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39278 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755766AbYCFK1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 05:27:25 -0500
Date: Thu, 6 Mar 2008 11:27:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Pawel Plociennik <paplociennik@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.24] chroot= as a new kernel parameter
Message-ID: <20080306102712.GE13391@elte.hu>
References: <200803060001.38432.paplociennik@gmail.com> <47CF79E4.3030107@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CF79E4.3030107@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0030]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> Pawel Plociennik wrote:
>> Hi Andrew and other *real* hackers,
>>
>> I have sent a *last* version of a patch which it has added a new kernel parameter chroot=
>> It were discusioned a *long time* on a lkml so I hope that it will has been applied.
>
> It has been discussed and *rejected* a large number of times.
>
> This is completely useless bloat.

why is it useless? Would it be more acceptable were it made dependent on 
a .config option?

	Ingo
