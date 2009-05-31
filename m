Return-Path: <linux-kernel-owner+w=401wt.eu-S1753612AbZEaMYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbZEaMYb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 08:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbZEaMYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 08:24:23 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:45126 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbZEaMYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 08:24:22 -0400
Message-ID: <4A2275EF.2050409@cs.helsinki.fi>
Date: Sun, 31 May 2009 15:19:59 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: "Larry H." <research@subreption.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, pageexec@freemail.hu,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page	allocator
References: <20090530082048.GM29711@oblivion.subreption.com> <20090530173428.GA20013@elte.hu> <20090530180333.GH6535@oblivion.subreption.com> <20090530182113.GA25237@elte.hu> <20090530184534.GJ6535@oblivion.subreption.com> <20090530190828.GA31199@elte.hu> <4A21999E.5050606@redhat.com> <84144f020905301353y2f8c232na4c5f9dfb740eec4@mail.gmail.com> <20090531001052.40ac57d2@lxorguk.ukuu.org.uk> <84144f020905302314w12c4c7f8jc8241e36c847f53e@mail.gmail.com> <20090531121636.GC10598@oblivion.subreption.com>
In-Reply-To: <20090531121636.GC10598@oblivion.subreption.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Larry H. wrote:
>> No, there's nothing wrong with ksize() I am aware of. Yes, Larry has
>> been saying it is but hasn't provided any evidence so far.
> 
> Excuse me, do you have an attention or reading disorder? Compound pages
> and SLOB anyone? Duplication of test branches for pointer validation?

I don't see a bug there. I cc'd Matt Mackall who is the author of SLOB. 
I am sure he will be able to spot the bug if it in fact exists (which I 
seriously doubt).

Feel free to prove me wrong by sending a patch to fix SLOB. But until 
then, please stop spamming my inbox. Thanks!

			Pekka
