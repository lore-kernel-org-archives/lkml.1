Return-Path: <linux-kernel-owner+w=401wt.eu-S1758835AbXFJO2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758835AbXFJO2p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 10:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754987AbXFJO2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 10:28:38 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:65109 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855AbXFJO2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 10:28:37 -0400
Message-Id: <466C09C5.80803@ds.jp.nec.com>
Date: Sun, 10 Jun 2007 23:25:09 +0900
From: IKEDA Munehiro <m-ikeda@ds.jp.nec.com>
User-Agent: Mozilla Thunderbird 1.0.2 (Windows/20050317)
X-Accept-Language: ja, en-us, en
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: Tsugikazu Shibata <tshibata@ab.jp.nec.com>, linux-kernel@vger.kernel.org,
       gregkh@suse.de
Subject: Re: [RFD] Documentation/HOWTO translated into Japanese
References: <20070610.204845.115909592.tshibata@ab.jp.nec.com> <9a8748490706100524o2dff1954ja7406f9303d8499f@mail.gmail.com>
In-Reply-To: <9a8748490706100524o2dff1954ja7406f9303d8499f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl wrote:
>> - Character encoding is ISO-2022-JP, which is normally used for email
>>   using Japanese.
> 
> 
> I think there's consensus that documents in the kernel source should
> be either plain ASCII or UTF-8 (doesn't UTF-8 work for japanese?).

Oh really?
UTF-8 works even for Japanese.  Thank you and Jan for the suggestion.

> If we start adding translated versions of documentation to the kernel
> source how should we organize the documents? Should each language get
> a sepperate directory in Documentation/ - like Documentation/JP/,
> Documentation/EN/, Documentation/DA/ etc?
> 
> With multiple translated versions of the documentation in the tree,
> don't we run the risk that the translations will quickly become
> outdated since most people updating the documentation won't be able to
> update the translations?
> 
> Since the common language of most kernel contributors is english I
> personally feel that we should stick to just that one language in the
> tree and then perhaps keep translations on a website somewhere. So the
> authoritative docs stay in the tree, in english, so that as many
> contributors as possible can read and update them. It would then be a
> seperate project to generate translations and keep them updated
> according to what's in the tree.  Perhaps we could get the kernel.org
> people to create an official space for that and then place a pointer
> to that site in Documentation/ somewhere.

Yes, that's the point.

At least for Japanese, there is a great activity "JF" as Tsugikazu 
Shibata mentioned.  It is a separate project from the tree, and it often 
happens that some documentations are outdated.  If we could merge them, 
they could be kept up-to-date IMHO.
But, on the other hand, it is fact that kernel tar ball would bloat.

Your opinion above as "creating official space in kernel.org and putting 
pointer in Documentation" seems good for me.

Hmm...

--
IKEDA, Munehiro

