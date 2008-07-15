Return-Path: <linux-kernel-owner+w=401wt.eu-S1755621AbYGOPU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621AbYGOPU1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 11:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753544AbYGOPUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 11:20:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60568 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753028AbYGOPUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 11:20:15 -0400
Date: Tue, 15 Jul 2008 08:20:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Stoyan Gaydarov <stoyboyker@gmail.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, gorcunov@gmail.com,
       akpm@linux-foundation.org
Subject: Re: From 2.4 to 2.6 to 2.7?
In-Reply-To: <87skubxxtq.fsf@basil.nowhere.org>
Message-ID: <alpine.LFD.1.10.0807150818300.3017@woody.linux-foundation.org>
References: <6d291e080807141910m573b29b2t753ea7c4db09902d@mail.gmail.com> <alpine.LFD.1.10.0807141914280.3017@woody.linux-foundation.org> <87skubxxtq.fsf@basil.nowhere.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jul 2008, Andi Kleen wrote:
> 
> Or you could just do it like emacs or Solaris and simply use a single number.

No, that would be horrible. The only point of changign the numbering would 
be to make the numbers smaller. Not fewer. I don't like "26" much as a 
version number, I'd like "131" even less.

So I'd much rather have something like "2.9.1" than "27", just because 
it's a hierarchy of simpler numbers.

		Linus
