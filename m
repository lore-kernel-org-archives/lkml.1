Return-Path: <linux-kernel-owner+w=401wt.eu-S1762263AbYEIE1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762263AbYEIE1d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 00:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760746AbYEIE1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 00:27:23 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:43405 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758949AbYEIE1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 00:27:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=M3miEaW1jR50J0ZxLPIYlxyBny+PgMJdo7crfFQu8wNOwtKLIFwze1TkMCnDsRRwgxoAq/7wYU7w1qKKZlbakpwyJatkK9IlR6xWALdwjUmpkL2PvX08MCXRjSF/UiN2RXnwNU6EtUeKsQKFXtNw7kMQcM6LK+S2GR+esfIyRTg=
Message-ID: <dd18b0c30805082127h51fb9264w62fb22139d2d35e9@mail.gmail.com>
Date: Fri, 9 May 2008 04:27:21 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: [PATCH] Re: [git patches] libata updates - (improve post-reset device ready test) regression
Cc: "Jeff Garzik" <jeff@garzik.org>,
       "Markus Trippelsdorf" <markus@trippelsdorf.de>,
       linux-ide@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Takashi Iwai" <tiwai@suse.de>,
       marc.c.dionne@gmail.com, dl9pf@gmx.de, bug-track@fisher-privat.net,
       sitsofe@yahoo.com
In-Reply-To: <4823BE6F.1090307@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080506154847.GA15299@havoc.gtf.org>
	 <20080507145616.GA2210@gentoox2.trippelsdorf.de>
	 <48231DAF.7070900@garzik.org> <4823BD8E.40109@gmail.com>
	 <4823BE6F.1090307@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 9, 2008 at 3:01 AM, Tejun Heo <htejun@gmail.com> wrote:
> Tejun Heo wrote:
>>
>> Markus, Alexey, Marc, which controllers are you using?
>
> Never mind, found the rest of the thread.
>
> Thanks.
>
> --
> tejun
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

This patch here is what fixes this issue for the macbook pro.
http://lkml.org/lkml/2008/5/8/245
regards;
-- 
Justin P. Mattock
