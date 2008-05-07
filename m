Return-Path: <linux-kernel-owner+w=401wt.eu-S933721AbYEGTYC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933721AbYEGTYC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 15:24:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932689AbYEGTXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 15:23:39 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:22622 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765825AbYEGTXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 15:23:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=DBAjCtfpi8glJkYwuIH4Lust53akYIaP12KaPp4uSc/kZIeiZ9Yzxh39EwWTPn4dVbznZJNGfnEFko3pQm8il5FKCvYIVFMVFK9orBlZJsMxP1zGUd7q7fFfki/tMXO27+TKrwcjKNWhBUkwJGIHVgHk1DhLCTpz+9Ymr0b+HMc=
Message-ID: <482201A8.90906@gmail.com>
Date: Wed, 07 May 2008 21:23:20 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Justin Mattock <justinmattock@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: nopage to fault
References: <dd18b0c30805071040i5e9c3d73uf60235b94dcce3c5@mail.gmail.com>	 <4821F3EE.1010309@gmail.com>	 <dd18b0c30805071207q1aaeb8daq7f63b02d3a58b5a@mail.gmail.com>	 <4821FFC0.5060907@gmail.com> <dd18b0c30805071220v7f486f79k6392d2c203b9326a@mail.gmail.com>
In-Reply-To: <dd18b0c30805071220v7f486f79k6392d2c203b9326a@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2008 09:20 PM, Justin Mattock wrote:
> On Wed, May 7, 2008 at 7:15 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
>> On 05/07/2008 09:07 PM, Justin Mattock wrote:
>>
>>> On Wed, May 7, 2008 at 6:24 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
>>>
>>>> On 05/07/2008 07:40 PM, Justin Mattock wrote:
>>>>
>>>>
>>>>> of the areas that I'm lost with is NOPAGE_SIGBUS for a return value.
>>>>> in mm.h The only options I see is VM_FAULT_SIGBUS, VM_FAULT_ERROR. If
>>>>>
>>>>>
>>>>  The former, next time, google little bit, please.

>>  The former constant you mentioned.
> 
> I think what I'm trying to figure out is what would you put in
> NOPAGE_SIGBUS's place since it no longer is in the kernel

Well, the former from the 2 you mentioned in the very first post.
