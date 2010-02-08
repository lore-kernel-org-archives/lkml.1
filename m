Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab0BHTQ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 14:16:28 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:41967 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159Ab0BHTQ0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 14:16:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=i92S5p+ItcWt/2nlYsDgGp2KqyUCSzHFt6yLMO0QukTi0UBmAlW67ZL5Qw5lx6s7oy
         pmUQ/15m+nZB/O6D75I4PzHnBKu9QYE/AhYsog+OP8jwO4YqyYp/Qgv44yuSmdzrUT+u
         OZjMajqAFXySj/0FeiqOgfHf4cQupFx+445ME=
MIME-Version: 1.0
In-Reply-To: <445R0ey9hAI.A.2jB.iozbLB@chimera>
References: <4Ht3jFrT7uE.A.JI.-nzbLB@chimera>
	 <445R0ey9hAI.A.2jB.iozbLB@chimera>
Date: Mon, 8 Feb 2010 20:16:24 +0100
X-Google-Sender-Auth: f8bbe6e919f5d746
Message-ID: <e2e108261002081116m5c13d081p161d8697464253f1@mail.gmail.com>
Subject: Re: [Bug #15177] Asynchronous writes up to 30% slower than in 
	previous kernel versions
From: Bart Van Assche <bvanassche@acm.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 7, 2010 at 11:28 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> This message has been generated automatically as a part of a summary report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let the tracking team
> know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15177
> Subject         : Asynchronous writes up to 30% slower than in previous kernel versions
> Submitter       : Bart Van Assche <bart.vanassche@gmail.com>
> Date            : 2010-01-30 16:38 (9 days old)

The regression compared to 2.6.32 is solved in 2.6.33-rc7 for the
specific test mentioned in the Bugzilla entry. The regression compared
to 2.6.28 is not yet solved though, so I'm not sure what should happen
with this bug entry.

Bart.
