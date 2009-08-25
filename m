Return-Path: <linux-kernel-owner+w=401wt.eu-S932656AbZHYXhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932656AbZHYXhp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 19:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932601AbZHYXhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 19:37:40 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:38732 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932651AbZHYXhh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 19:37:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=JpzApYKk53KrhbjGBVUkS11HUV8y1RyH7OHZDTwtsocKgKRrDI/uqN8CAmAANfW7XV
         S7Y6lnNpS0nI47QELybALirGqrN9iZ1xJe2uKSR3aSGBD8+hTCqPgT24azfYGU7hgNXw
         sB5jMAZpS9RKSDxST+sxrdyqDFSSXpEmKLrlA=
MIME-Version: 1.0
Reply-To: q-funk@iki.fi
In-Reply-To: <_yaHeGjHEzG.A.sS.WtGlKB@chimera>
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera>
	 <_yaHeGjHEzG.A.sS.WtGlKB@chimera>
Date: Wed, 26 Aug 2009 02:37:37 +0300
X-Google-Sender-Auth: 40fb25901e96cd87
Message-ID: <11fae7c70908251637p2fe53296g1c2e65b9fca5e5a1@mail.gmail.com>
Subject: Re: [Bug #13941] x86 Geode issue
From: =?UTF-8?Q?Martin=2D=C3=89ric_Racine?= <q-funk@iki.fi>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, it still is valid.

Screen dumps of the kernel panic were provided.  Can we get anyone to
investigate them now and find a fix? Thanks!

On Tue, Aug 25, 2009 at 11:34 PM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
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
> Date            : 2009-08-03 12:58 (23 days old)
> References      : http://marc.info/?l=linux-kernel&m=124930434732481&w=4
>
>
>
