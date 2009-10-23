Return-Path: <linux-kernel-owner+w=401wt.eu-S1752303AbZJWPK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbZJWPK4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 11:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbZJWPKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 11:10:55 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:57926 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbZJWPKz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 11:10:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BO4KsPx58erwQPSpP4Kewf82P8LVKj9cN1p0nbbzfvHhpWmK4YAOJUOTn21cikT//k
         XNEht7XmF2wYgWiAJONh4XyVu+/KJetg/gCxh7dhg2QNSClwI5p7Am1sF0wbG0VxPkA0
         EkUWiKV8+/VmtBG5DwmB6YZvakP3iVurfeGNY=
MIME-Version: 1.0
In-Reply-To: <4AD27044.7030907@bigpond.net.au>
References: <27a8ee1b0910100017h75579306i42463e309bd26712@mail.gmail.com>
	 <27a8ee1b0910100018g1207c5b1uf742677b55f2f99b@mail.gmail.com>
	 <4AD27044.7030907@bigpond.net.au>
Date: Fri, 23 Oct 2009 20:40:59 +0530
Message-ID: <27a8ee1b0910230810x255702eepa17734514cbf525f@mail.gmail.com>
Subject: Re: How to add scheduler
From: Pankaj Parakh <me.pankajparakh@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Peter Williams <pwil3058@bigpond.net.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Thanks for showing your interest, I am student and I am working on a
project similar to yours i.e. to have a facility where in one can swap
scheduler in run-time, but I am in very initial state of learning so I
wanted to try a simple RR scheduler, objective of doing it is to learn
about different interfaces in modular design(introduced from 2.6.23
with CFS). I do not have any constraint with version of linux. I am
ready to take part with you provided you do not have any issue.


On Mon, Oct 12, 2009 at 5:24 AM, Peter Williams <pwil3058@bigpon.net.au> wrote:
> On 10/10/09 17:18, Pankaj Parakh wrote:
>>
>>  Hi all,
>>
>>  I want to add my scheduler in linux 2.6.25.3, which have modular
>> design, is there any document which can explain that modular design of
>> generic scheduler in detail. I wanted to try my scheduler.
>>
>> Any guidance..
>
> Not really an answer to you question but related:  I'm resurrecting the CPU
> plug in scheduler project (to be renamed CPU_PISCH) which aims to provide an
> interface for people such as your self to implement CPU schedulers against
> and I was wondering if you were interested in adding your scheduler to this
> project?  Or taking part in other ways?
>
> Thanks,
> Peter
> PS I'm currently working with respect to the latest kernel rather than
> 2.6.25.3 (in case that's an issue).
> --
> Peter Williams                                   pwil3058@bigpond.net.au
>
> "Learning, n. The kind of ignorance distinguishing the studious."
>  -- Ambrose Bierce
>



-- 
Pankaj Parakh
