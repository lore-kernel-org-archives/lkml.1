Return-Path: <linux-kernel-owner+w=401wt.eu-S1761216AbYDKSfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761216AbYDKSfv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 14:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760228AbYDKSfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 14:35:44 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:26561 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760189AbYDKSfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 14:35:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=J/PWrY1CIuRG9vwy793EZCFAsVSTJ5QLdMzcZGjG1wOMiMtgFwBmORlt1pNwynTkurzVKa5z6qxMJEow6dU+c1MRUhzUUbsG5KJamsZqCDIFdIdwQBWII9zUbkSFfaU4+PBXpHpIXwoW2nn0C8Vy9JAn46NM0wEfuQE3imQYCCI=
Message-ID: <175f5a0f0804111135s504bcb8cpedfd1666a0b3dc24@mail.gmail.com>
Date: Fri, 11 Apr 2008 20:35:42 +0200
From: "H. Willstrand" <h.willstrand@gmail.com>
To: "Marc Perkel" <mperkel@yahoo.com>
Subject: Re: AMD Quad Core clock problem?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <632977.6298.qm@web52505.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <632977.6298.qm@web52505.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 8:27 PM, Marc Perkel <mperkel@yahoo.com> wrote:
> I was just wondering if there were any known issues
>  with AMD quad core phenom clock drift problems? I';m
>  running a 2.6.24 kernel and it's losing time. I
>  remember the first dual core AMD chips had a lot of
>  clock issues.
>
>  If this is something new let me know what information
>  to check and post to this list.
>
I don't know if this is related, however check
http://marc.info/?l=linux-kernel&m=120784269708442&w=2

Br H.Willstrand

>
>  Marc Perkel
>  Junk Email Filter dot com
>  http://www.junkemailfilter.com
>
>  __________________________________________________
>  Do You Yahoo!?
>  Tired of spam?  Yahoo! Mail has the best spam protection around
>  http://mail.yahoo.com
>  --
>  To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  Please read the FAQ at  http://www.tux.org/lkml/
>
