Return-Path: <linux-kernel-owner+w=401wt.eu-S1755240AbZBQTru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbZBQTru (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 14:47:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753003AbZBQTrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 14:47:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58444 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793AbZBQTrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 14:47:39 -0500
Date: Tue, 17 Feb 2009 20:47:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [tip:perfcounters/core] x86: remove stale
	arch/x86/include/asm/page_64.h.rej file
Message-ID: <20090217194723.GA17952@elte.hu>
References: <tip-ee8b53c1cfe33aecf0c77c0aa3ce437f0d84d831@kernel.org> <499B05A4.9020704@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499B05A4.9020704@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
>> Author:     Ingo Molnar <mingo@elte.hu>
>> AuthorDate: Tue, 17 Feb 2009 12:20:13 +0100
>> Commit:     Ingo Molnar <mingo@elte.hu>
>> CommitDate: Tue, 17 Feb 2009 12:20:13 +0100
>>
>> x86: remove stale arch/x86/include/asm/page_64.h.rej file
>>
>> Introduced by:
>>
>>   51c78eb: x86: create _types.h counterparts for page*.h
>>   
>
> Oops, sorry about that.  Shouldn't *.rej and *.orig be in .gitignore?

Yeah, probably. Note that .orig is already there in the toplevel 
.gitignore file. Please send a patch to Linus.

	Ingo
