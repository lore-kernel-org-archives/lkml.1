Return-Path: <linux-kernel-owner+w=401wt.eu-S1754414AbYJOWho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414AbYJOWho (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 18:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753408AbYJOWhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 18:37:35 -0400
Received: from 0x55512ece.adsl.cybercity.dk ([85.81.46.206]:18796 "EHLO
	sko.w0.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753193AbYJOWhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 18:37:35 -0400
Date: Thu, 16 Oct 2008 00:37:30 +0200 (CEST)
From: Hans Schou <linux@schou.dk>
X-X-Sender: linux@sko.w0.dk
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SiS55x, another x86 CPU
In-Reply-To: <Pine.LNX.4.64.0810152150070.25933@anakin>
Message-ID: <Pine.LNX.4.64.0810160027150.7873@sko.w0.dk>
References: <Pine.LNX.4.64.0810111143210.23344@sko.w0.dk> <87d4i5rq7i.fsf@basil.nowhere.org>
 <Pine.LNX.4.64.0810132240010.8901@sko.w0.dk> <20081014060616.GO12131@one.firstfloor.org>
 <Pine.LNX.4.64.0810140828220.11184@sko.w0.dk> <20081015100637.GS12131@one.firstfloor.org>
 <Pine.LNX.4.64.0810152150070.25933@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Oct 2008, Geert Uytterhoeven wrote:

> On Wed, 15 Oct 2008, Andi Kleen wrote:
>>> If any CR/LF in your file you must have added them yourself.
>>
>> There were definitely CR/LFs in the patch attachment you sent.
>> And no my mailer doesn't add them.
>
> Interesting. I didn't see any CR/LFs neither, after exporting the
> attachment to a file (I'm using pine).

As far as I could see, Pine does this:

1. If file has not extension like: .zip .jpg .exe, see it as ASCII
2. Add CR/LF to the file
3. Encode file as base64

On reception of the file:

1. Decode file as specified (in this case base64)
2. If it looks like a text file, convert CR/LF to LF.

> However, when doing a base64 decode on the raw attachment data, the
> CR/LFs did pop up.

I think time is up for getting rid of Pine and there stupid license. 
I'll check if "nail" can handle attachment correctly.

/hans
