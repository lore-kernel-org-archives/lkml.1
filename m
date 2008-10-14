Return-Path: <linux-kernel-owner+w=401wt.eu-S1753495AbYJNRjH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495AbYJNRjH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 13:39:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbYJNRiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 13:38:55 -0400
Received: from 0x55512ece.adsl.cybercity.dk ([85.81.46.206]:10215 "EHLO
	sko.w0.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128AbYJNRiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 13:38:54 -0400
Date: Tue, 14 Oct 2008 19:38:52 +0200 (CEST)
From: Hans Schou <linux@schou.dk>
X-X-Sender: linux@sko.w0.dk
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SiS55x, another x86 CPU
In-Reply-To: <20081014060616.GO12131@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0810140828220.11184@sko.w0.dk>
References: <Pine.LNX.4.64.0810111143210.23344@sko.w0.dk> <87d4i5rq7i.fsf@basil.nowhere.org>
 <Pine.LNX.4.64.0810132240010.8901@sko.w0.dk> <20081014060616.GO12131@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Oct 2008, Andi Kleen wrote:

>>> Your attachment seems to be windows line end damaged.
>>
>> Strange, Pine usually do it right with file attachments.
>
> It likely was added on some Windows system.

>> (what is "windows line end damaged"?)
>
> It used MSDOS style \r\n line terminators instead of Unix style \n.

Yes, I do know what a CR/LF (Carriage Return Line Feed) is but I 
didn't send any. I really dont understand what you are talking about.

I looked at the mail returned from vger.kernel.org which was fine, and 
this web-page is also OK.
http://www.gossamer-threads.com/lists/linux/kernel/983150

There is no CR here:
od -t x1 patch-sis55x | grep 0d

If any CR/LF in your file you must have added them yourself.

/hans
