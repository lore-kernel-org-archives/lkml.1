Return-Path: <linux-kernel-owner+w=401wt.eu-S1756628AbYJ3Aqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbYJ3Aqc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 20:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755215AbYJ3AqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 20:46:15 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:10593 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129AbYJ3AqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 20:46:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=cc:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:mime-version:subject:date:references
         :x-mailer;
        b=UtiZWRn/j1ERsWldJolbKFqnIkKqrkP92dzth1/ES2OeE37qqeGDefeOCnginHADA5
         K43iQYC38cTRv/J30EG7aIx4jNM7AeuYBz/OTE8Drs0SA07sJuJDlNsYV3bdgMKz3eCP
         r6Cc2RAvkrbesCI2ctKXQAdx/BDbg30z93ZX0=
Cc: "Moritz Muehlenhoff" <jmm@debian.org>, linux-kernel@vger.kernel.org,
       "Greg KH" <gregkh@suse.de>
Message-Id: <0246BB7A-4217-4309-898E-FFD6D42424C2@gmail.com>
From: Richard Holden <aciddeath@gmail.com>
To: "J.R. Mauro" <jrm8005@gmail.com>
In-Reply-To: <3aaafc130810291737i41716bd2r767150b47239b0a1@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: staging: me4000 and relation to other data acquisition devices
Date: Wed, 29 Oct 2008 18:46:10 -0600
References: <20081028154918.GA5630@mediacenter> <20081028163456.GA4278@suse.de> <20081028103337.a021e85d.rdunlap@xenotime.net> <20081028181402.GB4873@suse.de> <slrngghcgf.3do.jmm@inutil.org> <3aaafc130810291737i41716bd2r767150b47239b0a1@mail.gmail.com>
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 29, 2008, at 6:37 PM, J.R. Mauro wrote:

> On Wed, Oct 29, 2008 at 2:57 PM, Moritz Muehlenhoff <jmm@debian.org>  
> wrote:
>> Greg KH wrote:
>>> Of course, if someone doesn't want their code in the staging tree, I
>>> will not add it, that's just being "nice".
>>>
>>> As for what I will not put into staging, right now I'm sticking with
>>> drivers only, no filesystems (people have asked already).  I don't  
>>> think
>>> we have seen any drivers that I will not put into the staging tree  
>>> yet.
>>
>> Hi Greg,
>> Great effort with staging, thanks a lot!
>>
>> I've had a look at the out-of-tree kernel drivers currently present
>> in Debian, maybe you want to merge some into staging. The Debian
>> overview pages contain download links (the orig.tar.gz files):
>>
>> Voicetronix telephony hardware:
>> http://packages.qa.debian.org/v/vpb-driver.html
>> http://www.voicetronix.com.au/
>>

I'm working on the Quicknet IXJ driver currently and I could take this  
driver too if it would help.
>> Cheers,
>>       Moritz
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux- 
>> kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
> Greg,
>
> If you're interested in having the above drivers get into staging and
> need someone to email the developers about it, I humbly volunteer.
>
> ~J.R.
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


I guess I just volunteered to maintain the telephony drivers, though  
I'm still getting used to git. I'll send a Maintainers patch later  
today.

-Richard Holden
