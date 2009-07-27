Return-Path: <linux-kernel-owner+w=401wt.eu-S1755907AbZG0JfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbZG0JfB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 05:35:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755859AbZG0JfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 05:35:00 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:40637 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755718AbZG0Je7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 05:34:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=x0htCudUrmpILd54zl42EzOYMqIQyAengsAqbR6g+AcpfUO6YGx8Q+tOeZ3K8XFtZV
         PQe7fveEaHVTpgKcCBKvxgFGN4JwUCEVlc69QKn+M9aGvHwRTjcsCAd64SiVauCAMLfH
         yKxgSSkDWk1J+f+l3tKUeRceYHFqXhHAdE9yU=
MIME-Version: 1.0
In-Reply-To: <3zAHs5O6maO.A.eMB.9GObKB@chimera>
References: <Jya1GruKQpD.A.16.2GObKB@chimera>
	 <3zAHs5O6maO.A.eMB.9GObKB@chimera>
Date: Mon, 27 Jul 2009 10:27:01 +0100
Message-ID: <c6b1100b0907270227r4ab5a0b1q410160f92c94eae9@mail.gmail.com>
Subject: Re: [Bug #13846] Possible regression in rt61pci driver
From: Chris Clayton <chris2553@googlemail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/26 Rafael J. Wysocki <rjw@sisk.pl>:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).
>

This bug should remain open, although we are, I think, getting closer
to the cause, which seems to be related to some interaction between
the rt61 driver and mac80211 power saving.

>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13846
> Subject         : Possible regression in rt61pci driver
> Submitter       : Chris Clayton <chris2553@googlemail.com>
> Date            : 2009-07-13 8:27 (14 days old)
> References      : http://marc.info/?l=linux-kernel&m=124747418828398&w=4
>
>
>

-- 
No, Sir; there is nothing which has yet been contrived by man, by which
so much happiness is produced as by a good tavern or inn - Doctor Samuel
Johnson
