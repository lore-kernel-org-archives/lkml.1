Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab0BOHJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 02:09:47 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:65191 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825Ab0BOHJp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 02:09:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=UbhhQ4Fqvwuxo59sVH7E+uSQZnPpmzX7DitknnU++ySJEUuHkzADbBcttfFmrQqYdI
         xx1lT/7v0VVRAocnYwiBE62Ih7uzmDESOskfDBee9CGVhj78CAyclcVj4WZZ+b4QQXPP
         iBUuuGBi0PfCq4yhD3vgtlhictMupT8w8iTs8=
MIME-Version: 1.0
In-Reply-To: <4un6Gst5rKB.A.FwH.TjIeLB@chimera>
References: <Z5cmiqDComP.A.gyF.OiIeLB@chimera>
	 <4un6Gst5rKB.A.FwH.TjIeLB@chimera>
Date: Mon, 15 Feb 2010 08:09:43 +0100
X-Google-Sender-Auth: 095b973220b15c27
Message-ID: <e2e108261002142309m79648ccbo3779c43ac7e6ab4a@mail.gmail.com>
Subject: Re: [Bug #15177] Asynchronous writes up to 30% slower than in 
	previous kernel versions
From: Bart Van Assche <bvanassche@acm.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 12:38 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
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
> Date            : 2010-01-30 16:38 (16 days old)

Hello Rafael,

I thought your plan was to move this item to the 2.6.28 regression
list ? See also
http://groups.google.com/group/linux.kernel/msg/474762980e717a13?pli=1.

Bart.
