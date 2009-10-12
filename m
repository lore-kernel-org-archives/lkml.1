Return-Path: <linux-kernel-owner+w=401wt.eu-S1754531AbZJLHYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbZJLHYl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 03:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754499AbZJLHYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 03:24:40 -0400
Received: from mail-gx0-f212.google.com ([209.85.217.212]:57883 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbZJLHYk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 03:24:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DpNrTrAS21Z1R+meGI7seeLiI0aqR0I1wfYle6u4FooZJYjEmugtH17VGeydb4M0aM
         uLyPsDA6wqJ/z8l4zfFMuQgbA9sS0WeV3YMBCieBlc9XHyqV/X8Jm175bK2CrK0/K7we
         iMkLd1RgG/c1AY5YydPk0KnsOYmfUI6JcMHyw=
MIME-Version: 1.0
In-Reply-To: <L6tb-VyKHZK.A.n4E.T1l0KB@chimera>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
	 <L6tb-VyKHZK.A.n4E.T1l0KB@chimera>
Date: Mon, 12 Oct 2009 09:24:02 +0200
Message-ID: <b637ec0b0910120024h463c78e5l67f646f262e0c13c@mail.gmail.com>
Subject: Re: [Bug #13943] WARNING: at net/mac80211/mlme.c:2292 with ath5k
From: Fabio Comolli <fabio.comolli@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually I switched to -32rc so I can't test it anymore... Sorry. I
can confirm it for 2.6.31.1.

Regards,
Fabio

On Mon, Oct 12, 2009 at 1:01 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.30 and 2.6.31.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13943
> Subject         : WARNING: at net/mac80211/mlme.c:2292 with ath5k
> Submitter       : Fabio Comolli <fabio.comolli@gmail.com>
> Date            : 2009-08-06 20:15 (67 days old)
> References      : http://marc.info/?l=linux-kernel&m=124958978600600&w=4
>
>
>
