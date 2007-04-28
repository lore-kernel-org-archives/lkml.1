Return-Path: <linux-kernel-owner+w=401wt.eu-S1753913AbXD1O2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbXD1O2u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 10:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753926AbXD1O2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 10:28:50 -0400
Received: from gw.goop.org ([64.81.55.164]:38613 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913AbXD1O2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 10:28:49 -0400
Message-ID: <46335A26.4020109@goop.org>
Date: Sat, 28 Apr 2007 07:28:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: fix PSE pagetable construction
References: <4632AE54.7030200@goop.org> <m1zm4tghyf.fsf@ebiederm.dsl.xmission.com> <200704281229.48597.ak@suse.de>
In-Reply-To: <200704281229.48597.ak@suse.de>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> My preference would be for whoever had:
>> paravirt_ops-hooks-to-set-up-initial-pagetable.patch
>>     
>
> That would be very messy because there are many followup dependencies.
>
> But once we have a good fix aggreed by everybody I can merge it into the 
> initial patch then.

I'm working on an incremental fix.

    J
