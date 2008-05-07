Return-Path: <linux-kernel-owner+w=401wt.eu-S933380AbYEGTPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933380AbYEGTPs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 15:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758371AbYEGTPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 15:15:33 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:14188 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760097AbYEGTPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 15:15:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=f2X6vL0jLY9kg4HyP+KxJLOdvw/I9OZyxDJI5vWk3I9AH9Qlj9BD6+iBmhd2o4y2LqlF5tKzlxgCuUf0Jclsxfw3J3t9eUNMQ/2CLoGR8m1gPxFq4tjLbfEiuY9mDzlvQhiiefoCip6EgM+r5mwm53VocvfSgvEewP1SAul0hz8=
Message-ID: <4821FFC0.5060907@gmail.com>
Date: Wed, 07 May 2008 21:15:12 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Justin Mattock <justinmattock@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: nopage to fault
References: <dd18b0c30805071040i5e9c3d73uf60235b94dcce3c5@mail.gmail.com>	 <4821F3EE.1010309@gmail.com> <dd18b0c30805071207q1aaeb8daq7f63b02d3a58b5a@mail.gmail.com>
In-Reply-To: <dd18b0c30805071207q1aaeb8daq7f63b02d3a58b5a@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2008 09:07 PM, Justin Mattock wrote:
> On Wed, May 7, 2008 at 6:24 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
>> On 05/07/2008 07:40 PM, Justin Mattock wrote:
>>
>>> of the areas that I'm lost with is NOPAGE_SIGBUS for a return value.
>>> in mm.h The only options I see is VM_FAULT_SIGBUS, VM_FAULT_ERROR. If
>>>
>>  The former, next time, google little bit, please.
>>
> 
> Thanks for the help,
>  you mean the former definition which was taken out "NOPAGE_SIGBUS",
> or former as in an interface located somewhere in the kernel.
> regards;

The former constant you mentioned. I suppose you are asking what's the 
NOPAGE_SIGBUS opposite in fault handler, right?
