Return-Path: <linux-kernel-owner+w=401wt.eu-S965496AbXBFWGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965496AbXBFWGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 17:06:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965541AbXBFWGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 17:06:36 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:32880 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965496AbXBFWGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 17:06:35 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Luigi Genoni" <luigi.genoni@pirelli.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@osdl.org>,
       <linux-kernel@vger.kernel.org>, "Lu, Yinghai" <yinghai.lu@amd.com>,
       "Natalie Protasevich" <protasnb@gmail.com>, "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH 2/2] x86_64 irq:  Handle irqs pending in IRR during irq migration.
References: <200701221116.13154.luigi.genoni@pirelli.com>
	<m1veik3woc.fsf_-_@ebiederm.dsl.xmission.com>
	<20070206073616.GA15016@elte.hu>
	<200702061012.25910.luigi.genoni@pirelli.com>
Date: Tue, 06 Feb 2007 15:05:25 -0700
In-Reply-To: <200702061012.25910.luigi.genoni@pirelli.com> (Luigi Genoni's
	message of "Tue, 6 Feb 2007 10:12:25 +0100")
Message-ID: <m1sldjq6vu.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Luigi Genoni" <luigi.genoni@pirelli.com> writes:

> btw, I tested in on ( CPU and no way to reproduce the bug, (no messages 
> appeared and load average was quite as high as exspected). 
> Going to test an a 16 CPU (the same who triggered the bug at the beginning) 
> immediatelly when it will be free.

Thanks.  Hopefully that will confirm I have properly tracked this bug.

Eric
