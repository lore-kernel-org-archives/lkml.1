Return-Path: <linux-kernel-owner+w=401wt.eu-S1751448AbZLDFWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448AbZLDFWV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 00:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750885AbZLDFWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 00:22:20 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:51301 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbZLDFWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 00:22:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=OAqkp7/JHXLC2NfHC+HoIXpaEvaFuqVUMgzSuAKoE4yVnUDyBSLzvCwlMwD7AB4nt+
         P5GtuWlHVr33VidcQQol4qSh+lCSj7hV5ivS3y3849EqKXDddSicxOObKZLZ/F5oZoki
         Q16IFOvq8jf1m5NI/KpXmfjtO+os7dpcwEyF4=
Message-ID: <4B189C94.4080404@gmail.com>
Date: Thu, 03 Dec 2009 21:22:28 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Miles Lane <miles.lane@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ath9k-devel@venema.h4ckr.net,
       linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] BUG kmalloc-8192: Poison overwritten
References: <dd18b0c30912021427x4d1d952tcdd98bb9d816b67c@mail.gmail.com> 	<43e72e890912021516k736db118j217dc92496db8f19@mail.gmail.com> 	<4B182F79.7060103@gmail.com> <43e72e890912031345m3f5adb9nca754e33a858c923@mail.gmail.com>
In-Reply-To: <43e72e890912031345m3f5adb9nca754e33a858c923@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/09 13:45, Luis R. Rodriguez wrote:


> I think waiting to be able to reproduce is best, and appreciate your
> patience on this. Maybe Miles Lanes also cannot reproduce easily and
> that may explain why he hasn't replied.
>
>    Luis
>

o.k., did some more experimenting
but came up with something other than
what I was hoping for(something with s2ram),
Anyways the two patches applied clean,
I'll just run  the system with these in,
and if somebody comes along with more expertise
on this I can try their advice(or if I somehow find
a way to reproduce this).

Justin P. Mattock
