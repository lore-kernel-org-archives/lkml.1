Return-Path: <linux-kernel-owner+w=401wt.eu-S1759102AbYAFQeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759102AbYAFQeR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 11:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753831AbYAFQeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 11:34:05 -0500
Received: from fk-out-0910.google.com ([209.85.128.187]:14236 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbYAFQeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 11:34:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=LwHVJqhPpV0ItCnsejaC+bcNQaOkWrGmOK9QsiOFv2x5hE2Bg7RfjFyEL7LUxK7ic2sSNykKA4V3eC+3Ds2LoEKW+sTrrGaSYJ6W2WO3vu4+Rj1HgSVu2HAqIYmoWhemSZOpBcdKaIpwf/UNIR5FRXbN3awFqNs+t8EsbDa9aww=
Message-ID: <478102F5.5020701@gmail.com>
Date: Sun, 06 Jan 2008 17:33:57 +0100
From: =?ISO-8859-1?Q?Miguel_Bot=F3n?= <mboton@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH] x86: ioport_{32|64}.c unification -v2
References: <4780EC61.4020007@gmail.com> <20080106150417.GA14146@elte.hu> <4780F880.8030903@gmail.com> <20080106161741.GA10824@elte.hu>
In-Reply-To: <20080106161741.GA10824@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Miguel Botón <mboton@gmail.com> wrote:
> 
>>> in what way have you tested it? Have you tried iopl() and ioperm() 
>>> syscalls to check whether they properly block/allow port IO?
>> I made a little app to check that iopl() and ioperm() were working 
>> properly.
> 
> cool, thx. Could you check whether LTP includes something like that 
> already - and if not, send it to the LTP maintainers?
> 
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

of course ;)

---
	Miguel Botón
