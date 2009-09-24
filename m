Return-Path: <linux-kernel-owner+w=401wt.eu-S1754597AbZIXA6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbZIXA6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 20:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754586AbZIXA6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 20:58:19 -0400
Received: from mail-yw0-f174.google.com ([209.85.211.174]:60752 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857AbZIXA6S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 20:58:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pFm34P6M1y30oabav4CGuE/BYCZnJEZMlCjzEbxNXkm3jH4QMSvbpssRkkbEa85091
         v1DLj9z6P+cAWyM/h8cTYvOoIdAvY6XDGveH+JbCOsjXoIg67fyCN/zULxo/JGNlgkYY
         Yzzi277o4z9sX25Uh/NDYA86TBbGh/y6wVvFg=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0909231737001.811@gandalf.stny.rr.com>
References: <1253615424.20345.76.camel@Palantir>
	 <1253625878.6575.34.camel@desktop>
	 <1253628061.20345.173.camel@Palantir>
	 <alpine.DEB.2.00.0909231737001.811@gandalf.stny.rr.com>
Date: Thu, 24 Sep 2009 09:58:22 +0900
Message-ID: <49b7c2350909231758j593374f9x7fd61b26dc5ad653@mail.gmail.com>
Subject: Re: [RFC][PATCH] SCHED_EDF scheduling class
From: GeunSik Lim <leemgs1@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Raistlin <raistlin@linux.it>, Daniel Walker <dwalker@fifo99.com>,
       Peter Zijlstra <peterz@infradead.org>, claudio@evidence.eu.com,
       michael@evidence.eu.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, johan.eker@ericsson.com, p.faure@akatech.ch,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 24, 2009 at 6:39 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> So, I'm sorry, but, for now, the only thing I can do is attaching the
>> patch, hoping it works. The next one will be stop using Evolution! :-/
>>
>
> Hmm, I use evolution with no issues with patches. I just set it to
> Preformatted (from Normal), and then hit "Insert->Text File ..." and it
> inlines quite nicely.
>
> /me says this while sending via pine ;-)
> -- Steve
Me too.
I also evolution(ver.2.8.0) with no issues like Steven.
For example,
1) select "Preformat" select form in Compse Message window.
2) and then, hit "Insert - Test File ... "
That's all.


> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Regards,
GeunSik Lim ( Samsung Electronics )
Blog : http://blog.naver.com/invain/
e-Mail: geunsik.lim@samsung.com
           leemgs@gmail.com , leemgs1@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
