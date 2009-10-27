Return-Path: <linux-kernel-owner+w=401wt.eu-S1755995AbZJ0CEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995AbZJ0CEL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 22:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753770AbZJ0CEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 22:04:10 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:35750 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbZJ0CEJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 22:04:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iVrFB+mJwWjC8P6noY+VWqhZbKVa2j0D50rlftCEBr6keK/dxVV/5B4Pn8EC649Aqa
         XDoRYgq9Lw6QVURPU9A9+R8+BWriMb9UBaNNT84YEtEsir8kZBWAD5+Js31DfYEX0gAK
         U7WFk4iXp7cPlYt4i89o+MF/+mANzOpUyd/F0=
MIME-Version: 1.0
In-Reply-To: <6dRYo8ss7vL.A.x7E.4qe5KB@chimera>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera>
	 <6dRYo8ss7vL.A.x7E.4qe5KB@chimera>
Date: Tue, 27 Oct 2009 10:04:12 +0800
Message-ID: <2674af740910261904m13985d9ck46e5d665517ca6a6@mail.gmail.com>
Subject: Re: [Bug #14481] umount blocked for more than 120 seconds after USB 
	drive removal
From: Yong Zhang <yong.zhang0@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Robert Hancock <hancockrwd@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 27, 2009 at 2:56 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.31.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14481
> Subject         : umount blocked for more than 120 seconds after USB drive removal
> Submitter       : Robert Hancock <hancockrwd@gmail.com>
> Date            : 2009-10-21 5:26 (6 days old)
> References      : http://marc.info/?l=linux-kernel&m=125610280532245&w=4
>
>

I met the same problem on 2.6.32-rc5

Thanks,
Yong

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
