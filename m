Return-Path: <linux-kernel-owner+w=401wt.eu-S1757808AbZJEAX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808AbZJEAX7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 20:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754959AbZJEAX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 20:23:59 -0400
Received: from mail-yw0-f173.google.com ([209.85.211.173]:38609 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584AbZJEAX6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 20:23:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FdQNyYcinxjvm8dhnrPqFRzenzAJDU0DQQXLInapEUAlotoiyTsQHzs3ufdTod+Ea9
         XTNSrR3ztycaLabkoHhHpFKivSj8uTvPuXerNr/xsagYggMLFiW3s0w4DVe7EfPzdzZu
         mxhdCri1X/KeHuoDKVNdUd0jkaiE/vaUSLJS8=
MIME-Version: 1.0
In-Reply-To: <tkrat.f4970b0de587f089@s5r6.in-berlin.de>
References: <1254262438-31323-1-git-send-email-justinmattock@gmail.com>
	 <1254262438-31323-2-git-send-email-justinmattock@gmail.com>
	 <tkrat.f4970b0de587f089@s5r6.in-berlin.de>
Date: Sun, 4 Oct 2009 17:23:21 -0700
Message-ID: <dd18b0c30910041723p9b503f3ta84867d6ec241db9@mail.gmail.com>
Subject: Re: [PATCH] Update the e-mail for the userspace tools to use 
	ohci1394_dma=early for debugging.
From: Justin Mattock <justinmattock@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 3, 2009 at 1:15 AM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> On 29 Sep, Justin P. Mattock wrote:
>> ---
>>  Documentation/debugging-via-ohci1394.txt |    8 ++++----
>>  1 files changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/Documentation/debugging-via-ohci1394.txt b/Documentation/debugging-via-ohci1394.txt
>> index 59a91e5..8be3c78 100644
>> --- a/Documentation/debugging-via-ohci1394.txt
>> +++ b/Documentation/debugging-via-ohci1394.txt
>> @@ -64,14 +64,14 @@ be used to view the printk buffer of a remote machine, even with live update.
>>
>>  Bernhard Kaindl enhanced firescope to support accessing 64-bit machines
>>  from 32-bit firescope and vice versa:
>> -- ftp://ftp.suse.de/private/bk/firewire/tools/firescope-0.2.2.tar.bz2
>> +- http://halobates.de/firewire/firescope-0.2.2.tar.bz2
>>
>>  and he implemented fast system dump (alpha version - read README.txt):
>> -- ftp://ftp.suse.de/private/bk/firewire/tools/firedump-0.1.tar.bz2
>> +- http://halobates.de/firewire/firedump-0.1.tar.bz2
>>
>>  There is also a gdb proxy for firewire which allows to use gdb to access
>>  data which can be referenced from symbols found by gdb in vmlinux:
>> -- ftp://ftp.suse.de/private/bk/firewire/tools/fireproxy-0.33.tar.bz2
>> +- http://halobates.de/firewire/fireproxy-0.33.tar.bz2
>>
>>  The latest version of this gdb proxy (fireproxy-0.34) can communicate (not
>>  yet stable) with kgdb over an memory-based communication module (kgdbom).
>> @@ -178,7 +178,7 @@ Step-by-step instructions for using firescope with early OHCI initialization:
>>
>>  Notes
>>  -----
>> -Documentation and specifications: ftp://ftp.suse.de/private/bk/firewire/docs
>> +Documentation and specifications: http://halobates.de/firewire/
>>
>>  FireWire is a trademark of Apple Inc. - for more information please refer to:
>>  http://en.wikipedia.org/wiki/FireWire
>
> I don't see this patch in linux-next yet, hence I picked it up committed
> it to linux1394-2.6.git.
> --
> Stefan Richter
> -=====-==--= =-=- ---==
> http://arcgraph.de/sr/
>
>

Alright cool.

-- 
Justin P. Mattock
