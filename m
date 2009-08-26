Return-Path: <linux-kernel-owner+w=401wt.eu-S1756816AbZHZGOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbZHZGOF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756774AbZHZGOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:14:03 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:37451 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756758AbZHZGOB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:14:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=jMi16IEJPXRnMqpUJ7a0Ji0CIgRw0Eo4Hs7MGKPufoOou+74EZpoPk5o9OoV5VxnjW
         LSUbdjj1hQEn6O5uqsHC17wTujfXJ2RO+40rWGgXW73obJ1GPht+Zh348r4MKLeqPKnL
         KVWSw6hsBC9j/XJXcjQheFbv+Hxd+wRoy//gU=
MIME-Version: 1.0
In-Reply-To: <Cg6cQYLdUxG.A.f2B.l0GlKB@chimera>
References: <JuOd1ZASH0B.A.YGB.0zGlKB@chimera>
	 <Cg6cQYLdUxG.A.f2B.l0GlKB@chimera>
Date: Wed, 26 Aug 2009 09:14:02 +0300
X-Google-Sender-Auth: bab7578b9f610bd2
Message-ID: <84144f020908252314l364588bfi16e2d426cece2c5a@mail.gmail.com>
Subject: Re: [Bug #13646] warn_on tty_io.c, broken bluetooth
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 12:05 AM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.29 and 2.6.30.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13646
> Subject         : warn_on tty_io.c, broken bluetooth
> Submitter       : Pavel Machek <pavel@ucw.cz>
> Date            : 2009-06-19 17:05 (68 days old)
> References      : http://lkml.org/lkml/2009/6/19/187

Pavel, is this still an open issue? Plenty tty fixes went into 2.6.31
so maybe we need to backport some of them to -stable?
