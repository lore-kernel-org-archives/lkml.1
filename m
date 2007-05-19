Return-Path: <linux-kernel-owner+w=401wt.eu-S1757178AbXESVu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178AbXESVu0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 17:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755621AbXESVuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 17:50:16 -0400
Received: from mail.gmx.net ([213.165.64.20]:54292 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755327AbXESVuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 17:50:15 -0400
X-Authenticated: #283898
X-Provags-ID: V01U2FsdGVkX197C1d4uId7a9PeUwy7Llg/A+i6kqcgl0m9zgoN5P
	NjpKKjE8G5MwGp
Subject: Re: VFS design question
From: Tobias Pflug <tobias.pflug@gmx.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <464F3CB2.9060401@zytor.com>
References: <1179569656.6558.349.camel@toontown>
	 <464F3CB2.9060401@zytor.com>
Content-Type: text/plain
Date: Sat, 19 May 2007 23:51:56 +0200
Message-Id: <1179611516.6558.357.camel@toontown>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-19 at 11:06 -0700, H. Peter Anvin wrote:
> Tobias Pflug wrote:
> > Hi,
> > 
> > A note in front: I realize that my question is rather broad and a bit
> > vague, sorry for that :)
> > 
> > The VFS is a great solution to transparently operate on different file
> > systems by designating an interface for file systems that separates 
> > file system specific code from higher levels. 
> > 
> > Doesn't however this very feature also represent a limiting factor in
> > some way? Surely you can map pretty much anything to the Common File
> > System model, but is or has the VFS interface design been limiting
> > in any way in contemporary file system design ? 
> > 
> 
> Why does this sound like "do my homework for me"?
> 
> 	-hpa

I tried to make it clear that I am clearly lacking expertise in this
topic. I am currently working on a somewhat related topic and was hoping
to get some reactions that would point me in the right directions as it
is somewhat hard to judge the VFS design when you do not have prior
experience in writing a file system on your own. Nowhere did I ask for a
10 paged review on the matter.

Enough blablabla

Any input would be welcome. Thanks.

-Tobi

