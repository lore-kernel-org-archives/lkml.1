Return-Path: <linux-kernel-owner+w=401wt.eu-S1757089AbZKBWME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089AbZKBWME (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 17:12:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757048AbZKBWMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 17:12:03 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:55406 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756944AbZKBWMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 17:12:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=bWAw+BOIlHwZnpTTMZ8A7DWYEpfdpen8hcLWidGToPZfXL5bZcuIzfQJZosv3CSgH0
         tVF8sLskY0JtQ04oBZ3ENRoihk1gL7n6VxOVruci7Cio8ibBHTLdioU7LYrDUh9o4ypo
         h4Vf71h0smxwrGUpxW+w4dK8tnjqlHrXHyloU=
Message-ID: <4AEF593E.5090404@gmail.com>
Date: Mon, 02 Nov 2009 14:12:14 -0800
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
well right now I'(on the macbook), seems to be going for a good ten 
minutes before
I hit an error with a header file(nss)

I'll see if I can get this thing to compile all the way through.
(knock on wood) then go from there.

Justin P. Mattock
