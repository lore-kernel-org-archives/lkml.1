Return-Path: <linux-kernel-owner+w=401wt.eu-S932946AbZJLSyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932946AbZJLSyl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 14:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757804AbZJLSyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 14:54:41 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:54944 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757783AbZJLSyj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 14:54:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:x-mailer:mime-version:subject:date:cc;
        b=N0wfOWi5Cacm93VjFNM11Zb2Qt7ZFvfFrWsnNjj0t/HbPq8Hh/N1ynW0BccfGolDUp
         EUt9f9hXS4InZ0xvMaalomVVGeCePfunx3MhTWP/3WUNJcpJAmejkrVGyiIp+dONHD4b
         vjWXg1vXSwSP8b9UJI5QboP99OZQA1HV52PBs=
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera> <L6tb-VyKHZK.A.PaB.Ozl0KB@chimera>
Message-Id: <C4F8B19E-F4B4-47F3-AE5B-4581C8E3F3AE@gmail.com>
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <L6tb-VyKHZK.A.PaB.Ozl0KB@chimera>
Content-Type: text/plain;
	charset=utf-8;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 8BIT
X-Mailer: iPhone Mail (7C144)
Mime-Version: 1.0 (iPhone Mail 7C144)
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
Date: Mon, 12 Oct 2009 11:53:54 -0700
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Boyan <btanastasov@yahoo.co.uk>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       =?utf-8?Q? "Fr=C3=A9d=C3=A9ric_L._W._Meunier" ?= 
	<fredlwm@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure where this stands. Right now all three machines I have seem  
to be having no issues with the kayboard
(xserver 1.6.*) I can go and build the latest xserver(1.7) to see if I  
hit something.

justin P. Mattock



On Oct 11, 2009, at 4:01 PM, "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.30 and 2.6.31.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.30 and 2.6.31.  Please verify if it still  
> should
> be listed and let me know (either way).
>
>
> Bug-Entry    : http://bugzilla.kernel.org/show_bug.cgi?id=14388
> Subject        : keyboard under X with 2.6.31
> Submitter    : Frédéric L. W. Meunier <fredlwm@gmail.com>
> Date        : 2009-10-07 20:19 (5 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e043e42bdb66885b3ac10d27a01ccb9972e2b0a3
> References    : http://marc.info/?l=linux-kernel&m=125494753228217&w=4
>
>
