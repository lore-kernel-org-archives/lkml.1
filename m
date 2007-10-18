Return-Path: <linux-kernel-owner+w=401wt.eu-S1765483AbXJRXQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765483AbXJRXQv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 19:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758923AbXJRXQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 19:16:43 -0400
Received: from mx1.suse.de ([195.135.220.2]:60508 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870AbXJRXQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 19:16:43 -0400
To: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andy Whitcroft <apw@shadowen.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: latest checkpatch
From: Andi Kleen <andi@firstfloor.org>
References: <20071015182118.GA4459@shadowen.org>
	<200710161759.l9GHxnkK012590@agora.fsl.cs.sunysb.edu>
	<20071017163916.GO21136@shadowen.org> <20071018111352.GA17039@elte.hu>
	<20071018192521.GC21136@shadowen.org> <20071018193929.GA22031@elte.hu>
	<4717BBD0.7070504@qumranet.com>
Date: Fri, 19 Oct 2007 01:16:41 +0200
In-Reply-To: <4717BBD0.7070504@qumranet.com> (Avi Kivity's message of "Thu\, 18 Oct 2007 22\:02\:24 +0200")
Message-ID: <p734pgoau92.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity <avi@qumranet.com> writes:

> This is more useful operating on an entire file, so the script can see
> all the context.
>
> A 'gcc -Windentation-contradicts-codeflow -Werror' would be nice.

I had a tool long ago on the Amiga which did exactly that. It double checked
that the indentation matched the code flow and flagged any differences. 
It was a dumb tool -- not a full C parser; but worked just fine. I got
it from some free software floppy disk. Unfortunately I forgot the
name and was never able to find it again.

These days emacs can do it for me though, but doing it in batch would
be nicer.
 
-Andi
