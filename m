Return-Path: <linux-kernel-owner+w=401wt.eu-S1759309AbXFOXHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759309AbXFOXHF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 19:07:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758252AbXFOXGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 19:06:37 -0400
Received: from 216-99-213-120.dsl.aracnet.com ([216.99.213.120]:44916 "EHLO
	clueserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758145AbXFOXGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 19:06:35 -0400
Date: Fri, 15 Jun 2007 16:06:34 -0700 (PDT)
From: alan <alan@clueserver.org>
X-X-Sender: alan@blackbox.fnordora.org
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Jack Stone <jack@hawkeye.stone.uk.eu.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
In-Reply-To: <467319C3.9020703@zytor.com>
Message-ID: <Pine.LNX.4.64.0706151601320.27993@blackbox.fnordora.org>
References: <46731169.2090002@hawkeye.stone.uk.eu.org> <467314E2.9010306@zytor.com>
 <Pine.LNX.4.64.0706151547200.27993@blackbox.fnordora.org> <467319C3.9020703@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2007, H. Peter Anvin wrote:

> alan wrote:
>>
>> ZFS is the cool new thing in that space.  Too bad the license makes it
>> hard to incorporate it into the kernel.  (I am one of those people that
>> believe that Linux should support EVERY file system, no matter how old
>> or obscure.)
>>
>
> I have details on the Luxor UFD-DOS filesystem, if you'd care to
> implement it.

Do you have example discs that can be mounted to test it?  If you do, I 
will consider doing it.

I have a couple of older DOS filesystems that got dropped out years ago 
that I actually need to mount disks that i may rewrite for 2.6.x.

Now all i need is the time.

And speaking of obscure information...

I have a bunch of PCMCIA spec documents from the PCMCIA standards 
association from the late 90s.  Would anyone involved in maintaining the 
PCMCIA code be interested in it?  (Especially if they are in Portland.) 
It has been a while since I have even needed to look at it and I hate for 
it to go to waste if it can be of any use.  (Bit late now, I know...)

-- 
"ANSI C says access to the padding fields of a struct is undefined.
ANSI C also says that struct assignment is a memcpy. Therefore struct
assignment in ANSI C is a violation of ANSI C..."
                                   - Alan Cox
