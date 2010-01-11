Return-Path: <linux-kernel-owner+w=401wt.eu-S1754148Ab0AKUFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab0AKUFv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 15:05:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750895Ab0AKUFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 15:05:49 -0500
Received: from mail-iw0-f197.google.com ([209.85.223.197]:47841 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137Ab0AKUFr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 15:05:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=grGNT6HFfjBmhWIzuMZmold7al/AB9F4DyvMEyjWO8CRZSwpOrLCdUOd9AdHJXoxBW
         uGIJwSC8n9ojlF8pzkYl/UmZOrA0WP49GzseUXc9YenDo5F3oI7lSnaFBbkj1GFK8PV6
         xAbQVBxdyEletdiZLvehht8zEMqayfkrQrVoY=
MIME-Version: 1.0
In-Reply-To: <201001112101.36950.rjw@sisk.pl>
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera> <omZ8aBZReyD.A.1h.vNlSLB@chimera> 
	<43e72e891001110705w43524cc6pac1ff6c971926eaf@mail.gmail.com> 
	<201001112101.36950.rjw@sisk.pl>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 11 Jan 2010 12:05:27 -0800
Message-ID: <43e72e891001111205x32fd367dlbb1f7c8a777d2f73@mail.gmail.com>
Subject: Re: [Bug #14874] Ath5k regression with commit 8bf3d79bc401ca417ccf9fc076d3295d1a71dbf5
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Joshua Covington <joshuacov@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 11, 2010 at 12:01 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday 11 January 2010, Luis R. Rodriguez wrote:
>> On Sun, Jan 10, 2010 at 2:32 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > This message has been generated automatically as a part of a report
>> > of recent regressions.
>> >
>> > The following bug entry is on the current list of known regressions
>> > from 2.6.32.  Please verify if it still should be listed and let me know
>> > (either way).
>>
>> This should be closed now.
>
> The patch linked below is not present in the Linus' tree at the moment AFAICS.
> Has it been fixed in a different way?

That patch is just a debug patch Michael worked on to actually get
some message from ath5k as to what is happening instead of it dying
without notice. A patch that actually fixes the issue would still be
needed, and that remains to be determined.

  Luis
