Return-Path: <linux-kernel-owner+w=401wt.eu-S1754061AbZHCBP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbZHCBP2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 21:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754042AbZHCBP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 21:15:26 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:52117 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007AbZHCBPL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 21:15:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DSNbWxGOIeSvUvGlfzxk6i+ONuAKc0Q99dXXtrQSIQE9HuL7rfyyzekicIns6NdT3d
         B7VM/1/QYNiOnCu5KRcmXq2U2Uq3jDyZ5PKWqYy2J1/R0/ruSIAmp7hM6V8eQFglaa4N
         IHDfFOoWAbDV1b2e2CpfYiHAoGR0vXfh8fu3M=
MIME-Version: 1.0
In-Reply-To: <iZB3Pj-uj3M.A.xaD.RdgdKB@chimera>
References: <Su1q3S6JjyO.A.jeB.hcgdKB@chimera>
	 <iZB3Pj-uj3M.A.xaD.RdgdKB@chimera>
Date: Mon, 3 Aug 2009 03:15:10 +0200
Message-ID: <c62985530908021815s547ac3aavb0d7a70c683ae79b@mail.gmail.com>
Subject: Re: [Bug #13813] Hangups in n_tty_read()
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/2 Rafael J. Wysocki <rjw@sisk.pl>:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13813
> Subject         : Hangups in n_tty_read()
> Submitter       : Johannes Weiner <hannes@cmpxchg.org>
> Date            : 2009-07-16 18:48 (18 days old)
> References      : http://marc.info/?l=linux-kernel&m=124777019920579&w=4


Johannes,

Does it still happen with latest mainline?
Also, could you send us your .config ?

Thanks,
Frederic.


>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
