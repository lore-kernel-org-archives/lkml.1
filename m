Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbYGXSw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbYGXSw0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 14:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754291AbYGXSwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 14:52:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44752 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754235AbYGXSwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 14:52:08 -0400
Date: Thu, 24 Jul 2008 11:48:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Whitehouse <swhiteho@redhat.com>
cc: Alexander Viro <aviro@redhat.com>, Evgeniy Dushistov <dushistov@mail.ru>,
       linux-kernel@vger.kernel.org
Subject: Re: parser: add const to parser token table (resend)
In-Reply-To: <1216916533.5376.1.camel@localhost.localdomain>
Message-ID: <alpine.LFD.1.10.0807241147160.3237@nehalem.linux-foundation.org>
References: <1216916533.5376.1.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Btw, the reason I didn't even look at this at first is that there is no 
such thing as a "parser" in the kernel, so I just dismissed the patch as 
being to somebody else (ie a sparse thing).

Now, if the subject had been something like

	UFS: add const to parser token table

I would have realized that it was relevant to my interests

What I'm trying to say is that subject lines matter ;)

		Linus
