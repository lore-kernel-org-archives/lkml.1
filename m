Return-Path: <linux-kernel-owner+w=401wt.eu-S1761482AbXEQHkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761482AbXEQHkF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 03:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754394AbXEQHj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 03:39:56 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:14479 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052AbXEQHjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 03:39:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NAFYhYljSozUE8veFt3kQhG7bNK6V3voLqUXHEzw8r3r4JCyrS75C+BHeKe/jKotjwl9Bh0yhRkti7p7VuraRsyLk6V493zWSaVWuZ1B2glze05QmorE+W+4jcDei7kVyQr3ZV6BRh6JN44QtMkmNJ/bD4W3UNXPstpeGZU9KU0=
Message-ID: <698310e10705170039u1270e8c4s71e551861444cb47@mail.gmail.com>
Date: Thu, 17 May 2007 11:39:54 +0400
From: "Marat Buharov" <marat.buharov@gmail.com>
To: "Anand Jahagirdar" <anandjigar@gmail.com>
Subject: Re: Fork bombing Attack
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <25ae38200705170025m23fe8ea9s81515ec8d1a0a137@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <25ae38200705170025m23fe8ea9s81515ec8d1a0a137@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

May be because Mars was in Scorpio?

On 5/17/07, Anand Jahagirdar <anandjigar@gmail.com> wrote:
> Dear Sir,
>              I just want to know whether fork bombing attack still
> exist on the machine having Distribution as Fedora Core 6 and Linux
> Kernel 2.6.x.?
>
>            additional Info :  I have set ulimit as 8000 and loged in
> as Guest User on machine having Distribution as Fedora Core 6 and
> Linux kernel 2.6.18. simple fork bombing program while(1) fork();
> killed the box and machine needed reboot. will any body please tell me
> why fork bombing attack killed the box even after setting ulimit as
> 8000?
>
> Regards
> Anand
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
