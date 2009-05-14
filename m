Return-Path: <linux-kernel-owner+w=401wt.eu-S1757028AbZENMTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028AbZENMTO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 08:19:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754440AbZENMS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 08:18:56 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:49657 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbZENMSz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 08:18:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=E9RVzkmnD6M5eLb/DYQQhP60pDughNpGRTjbgla5oVoi/cenH3cvNaSRh4DRR5Fcu0
         C4FhSgAaHLza9cRgXIg/ACKXcrux91HTQbrpQuQW+NAaQacYwqKV+hZ2ZNf7zOlYnqXF
         eZguNRzxXYCuzJtYpT2KaIJf20kfr9bCkqzI4=
MIME-Version: 1.0
In-Reply-To: <28c262360905140128q3458e39fu62def873f2d95ae0@mail.gmail.com>
References: <1242289418.31161.45.camel@centos51>
	 <28c262360905140128q3458e39fu62def873f2d95ae0@mail.gmail.com>
Date: Thu, 14 May 2009 21:18:55 +0900
Message-ID: <49b7c2350905140518k29d540a7o32265ba753d729d1@mail.gmail.com>
Subject: Re: [PATCH]append prompt in /debug/tracing/README file.
From: GeunSik Lim <leemgs1@gmail.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       williams <williams@redhat.com>, tglx <tglx@linutronix.de>,
       Jiri Kosina <trivial@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi minchan,

thank you for explanation about a trivial patch.

regards,
geunsik lim ( invain )

2009/5/14 Minchan Kim <minchan.kim@gmail.com>:
> Hi, GeunkSik.
>
> For fixing trivial typo, Let Cced trivial patch maintainer.
>
> TRIVIAL PATCHES
> P:  Jiri Kosina
> M:  trivial@kernel.org
> L:  linux-kernel@vger.kernel.org
> T:  git kernel.org:/pub/scm/linux/kernel/git/jikos/trivial.git
> S:  Maintained
>
>
> 2009/5/14 GeunSik Lim <leemgs1@gmail.com>:
>>
>> Dear Steven Rostedt,
>>
>>    Please, Append prompt in /debug/tracing/README file.
>>
>>    This is trivial issue. Fix typo Mini Howto file(README) for ftrace.
>>
>>    Signed-off-by: GeunSik Lim <geunsik.lim@samsung.com>
>>
>> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
>> index 1ce5dc6..a4726f5 100644
>> --- a/kernel/trace/trace.c
>> +++ b/kernel/trace/trace.c
>> @@ -2380,7 +2380,7 @@ static const char readme_msg[] =
>>        "# echo print-parent > /debug/tracing/trace_options\n"
>>        "# echo 1 > /debug/tracing/tracing_enabled\n"
>>        "# cat /debug/tracing/trace > /tmp/trace.txt\n"
>> -       "echo 0 > /debug/tracing/tracing_enabled\n"
>> +       "# echo 0 > /debug/tracing/tracing_enabled\n"
>>  ;
>>
>>  static ssize_t
>>
>>
>>
>> -----------------------------------------------
>> To unsubscribe from this list: send the line "unsubscribe linux-***"
>> in the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>> GeunSik Lim (ELS - OS Group - S/W Lab - SAIT - SAMSUNG)
>> e-Mail  :1) geunsik.lim@samsung.com
>>         2) leemgs@gmail.com , leemgs1@gmail.com
>> HomePage: http://intomail.dnip.net/invain/me/
>> -----------------------------------------------
>>
>
>
>
> --
> Kinds regards,
> Minchan Kim
>



-- 
Regards,
GeunSik Lim
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
