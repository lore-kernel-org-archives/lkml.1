Return-Path: <linux-kernel-owner+w=401wt.eu-S1757510AbZKCA4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510AbZKCA4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 19:56:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757434AbZKCA4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 19:56:34 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:18152 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757423AbZKCA4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 19:56:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=vNrtSuOH1pdvDOtSRdJR3wneQHiNmq3WUU65Uoez2LMnVnHrLRdvwPL2dBjDHQ7IXo
         aJ1VClxwjobgf8/lzHPoPAVQmYP22piqVfSUNVuUnVHlSqXrFY9uET/ZGaVkH9WYX8mB
         8wzC+7HfE6t5gwg/bxo8QDjVn6TSAGYhdACLk=
Message-ID: <4AEF7FCF.8000701@gmail.com>
Date: Mon, 02 Nov 2009 16:56:47 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009022519)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, gcc@gcc.gnu.org
Subject: Re: cc1plus invoked oom-killer: gfp_mask=0x280da, order=0, oom_adj=0
References: <dd18b0c30911021329g3c99a783n6b0a293240c3312c@mail.gmail.com>	 <4AEF53F5.4020107@gmail.com> <dd18b0c30911021402t6c8b9cd4p2e5d5dcad732d0ac@mail.gmail.com> <4AEF57AC.4090704@gmail.com>
In-Reply-To: <4AEF57AC.4090704@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> On 11/02/2009 11:02 PM, Justin Mattock wrote:
>    
>> Now with this oom-killer I'm
>> hitting this on an imac9,1 with
>> gcc (GCC) 4.5.0 20091029 (experimental)
>>      
>
> So there is probably a leak in the gcc chain. Does this happen with a
> stable gcc version?
>
>    
o.k. I think it's something with the latest gcc(snapshot)
right now she's been compiling firefox for 45min
(then crapped out because I compiled nss without sqlite)
without no omm-killer.

Justin P. Mattock

