Return-Path: <linux-kernel-owner+w=401wt.eu-S1763952AbXESSGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763952AbXESSGx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 14:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757023AbXESSGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 14:06:47 -0400
Received: from terminus.zytor.com ([192.83.249.54]:33197 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756819AbXESSGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 14:06:46 -0400
Message-ID: <464F3CB2.9060401@zytor.com>
Date: Sat, 19 May 2007 11:06:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Tobias Pflug <tobias.pflug@gmx.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: VFS design question
References: <1179569656.6558.349.camel@toontown>
In-Reply-To: <1179569656.6558.349.camel@toontown>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tobias Pflug wrote:
> Hi,
> 
> A note in front: I realize that my question is rather broad and a bit
> vague, sorry for that :)
> 
> The VFS is a great solution to transparently operate on different file
> systems by designating an interface for file systems that separates 
> file system specific code from higher levels. 
> 
> Doesn't however this very feature also represent a limiting factor in
> some way? Surely you can map pretty much anything to the Common File
> System model, but is or has the VFS interface design been limiting
> in any way in contemporary file system design ? 
> 

Why does this sound like "do my homework for me"?

	-hpa
