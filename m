Return-Path: <linux-kernel-owner+w=401wt.eu-S1030314AbXEHP5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030314AbXEHP5N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 11:57:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968181AbXEHP5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 11:57:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966267AbXEHP5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 11:57:09 -0400
Message-ID: <46409DC4.3000400@redhat.com>
Date: Tue, 08 May 2007 11:56:52 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@basil.nowhere.org>
Subject: Re: Please revert 86c0baf123e474b6eb404798926ecf62b426bf3a
References: <20070508134928.GA13212@flint.arm.linux.org.uk> <alpine.LFD.0.98.0705080815480.3974@woody.linux-foundation.org> <46409512.5000502@redhat.com> <20070508155449.GB13212@flint.arm.linux.org.uk>
In-Reply-To: <20070508155449.GB13212@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I'm not sure it'd make much sense for me to test it - I don't have x86
> based test boxes here.
>
> Assuming your intention is to revert this commit and replace it with your
> patch which doesn't change the semantics of __INIT, it shouldn't cause me
> any problems.
>
>   

Okay -- I'll generate a new patch later this afternoon, test, and submit.

P.
