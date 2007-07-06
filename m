Return-Path: <linux-kernel-owner+w=401wt.eu-S1762858AbXGFBB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762858AbXGFBB5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 21:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761437AbXGFBBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 21:01:49 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35523 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761429AbXGFBBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 21:01:48 -0400
Date: Thu, 5 Jul 2007 18:01:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jesper Juhl <jesper.juhl@gmail.com>
cc: Dmitry Torokhov <dtor@insightbb.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull][resend] Input updates for 2.6.22-rc7
In-Reply-To: <9a8748490707051650o16a260fexf9b8d62c4a65db4f@mail.gmail.com>
Message-ID: <alpine.LFD.0.98.0707051759450.9434@woody.linux-foundation.org>
References: <200707050111.43327.dtor@insightbb.com> 
 <alpine.LFD.0.98.0707051556000.9434@woody.linux-foundation.org> 
 <alpine.LFD.0.98.0707051618040.9434@woody.linux-foundation.org>
 <9a8748490707051650o16a260fexf9b8d62c4a65db4f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 6 Jul 2007, Jesper Juhl wrote:
> 
> > I'm constantly surprised by just how _many_ ways MUA's find to screw up.
> 
> 'pine' actually seems to work pretty damn well once you disable the
> flowed-text "feature".

Yes. And 'alpine', it's modern version, does even better, but you also 
need to make sure to disable "downgrade-multipart-to-text".

I've been using alpine for a while now, and it's nice to see it be utf-8 
capable and able to handle other charsets well.

So as a former pine user, I can recommend upgrading.

		Linus
