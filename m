Return-Path: <linux-kernel-owner+w=401wt.eu-S1753776AbZHMIwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776AbZHMIwW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 04:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753757AbZHMIwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 04:52:21 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:33579 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752AbZHMIwU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 04:52:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=dbJGo/oRK9TcbxJsNvSxXZG3VLCV5yVGTIHKRlkAfs5Ja9eDz1L/zMBkH1o3zGNohe
         9PZpAO3cYKZHzNoOqwV+LXZSNxucO6Pc6rkcF5vUmu+wEK2At4dU4ocVCkyLnpW5oVvs
         CvtEbuIiOg39P55luAPmaXT3PdS54oa7vwiGY=
MIME-Version: 1.0
Reply-To: q-funk@iki.fi
In-Reply-To: <u1L1PAbl8zG.A.UBD.ej1fKB@chimera>
References: <AuPdDySr74O.A.5LC.Pj1fKB@chimera>
	 <u1L1PAbl8zG.A.UBD.ej1fKB@chimera>
Date: Thu, 13 Aug 2009 11:52:20 +0300
X-Google-Sender-Auth: 68057a848154d28a
Message-ID: <11fae7c70908130152j21f9f183m4f1c49d91fc7a7f9@mail.gmail.com>
Subject: Re: [Bug #13941] x86 Geode issue
From: =?UTF-8?Q?Martin=2D=C3=89ric_Racine?= <q-funk@iki.fi>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, this bug is still valid.

Ubuntu kernel team member Leann Ogasawara and I are slowly bisecting
our way through the changes that took place since 2.6.30 to find the
commit that introduced this regression. Please stay tuned.

On Mon, Aug 10, 2009 at 12:10 AM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13941
> Subject         : x86 Geode issue
> Submitter       : Martin-Éric Racine <q-funk@iki.fi>
> Date            : 2009-08-03 12:58 (7 days old)
> References      : http://marc.info/?l=linux-kernel&m=124930434732481&w=4
>
>
>
