Return-Path: <linux-kernel-owner+w=401wt.eu-S1752707Ab0AYOKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab0AYOKb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 09:10:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173Ab0AYOK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 09:10:29 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:41215 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab0AYOK0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 09:10:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=WNG+zeqqJI114xOuFD/w0zR9OHLQx98gXOAdnFe93/PNNyCOHUEtVh6d0Y0kK3fdmZ
         4pn1ron+TPgBnmGinZ/pYPHeFiboUiYY8T7BcwEfeJOsbXKIW2o6mKtNuqx2Sdk6LmDj
         Ze1P4sbF2VAz1QLh3M76+B5JSiNyLzOAYL+GE=
MIME-Version: 1.0
In-Reply-To: <q60Z28d_9yH.A.70H.SZMXLB@chimera>
References: <pYFNu11z2aM.A.pJH.CZMXLB@chimera>
	 <q60Z28d_9yH.A.70H.SZMXLB@chimera>
Date: Mon, 25 Jan 2010 16:10:24 +0200
X-Google-Sender-Auth: 605639bd392e2226
Message-ID: <84144f021001250610q3160ea06tac5f645b84285388@mail.gmail.com>
Subject: Re: [Bug #15015] blank screen at random times in laptop when sitting 
	idle
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jithin Emmanuel <jithin1987@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 25, 2010 at 12:23 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15015
> Subject         : blank screen at random times in laptop when sitting idle
> Submitter       : Jithin Emmanuel <jithin1987@gmail.com>
> Date            : 2010-01-09 16:48 (16 days old)

FWIW, I might have seen this on my Macbook as well (screen went blank
but I didn't check the logs). I think I managed to unblank the screen
by hitting the "increase brightness" key. But as you say, the bug
doesn't trigger very often and I have no idea how to reproduce it at
will.

                         Pekka
