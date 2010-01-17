Return-Path: <linux-kernel-owner+w=401wt.eu-S1754439Ab0AQTTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab0AQTTB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 14:19:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753834Ab0AQTTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 14:19:00 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:40956 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab0AQTS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 14:18:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=oCxt8RHk07Ot8yhPKh35zWi+pJKcpQMOcUXF3G/zgEWcSt7AwXPiy4F/HgqdPolsmU
         tELhcynlkdNBZpDYDJkSi00MzvmtAJwNOqCDK+w27zNcoaUwjTMjYTSU/bQjHJj02iQ7
         1rS1NrJpL+UCH9ge3LIwFOgk5GDePcx3Cue+U=
MIME-Version: 1.0
In-Reply-To: <1263250075.29868.4750.camel@calx>
References: <1262997509-5680-1-git-send-email-linus.walleij@stericsson.com>
	 <1263250075.29868.4750.camel@calx>
Date: Sun, 17 Jan 2010 20:18:58 +0100
Message-ID: <63386a3d1001171118n6ac88fccx12b7fdfeda204f50@mail.gmail.com>
Subject: Re: [PATCH] Use AB3100 MFD core IRQ for interrupt randomness
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
       Robin Getz <rgetz@blackfin.uclinux.org>, Matt Mackall <mpm@selenic.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/11 Matt Mackall <mpm@selenic.com>:

> Acked-by: Matt Mackall <mpm@selenic.com>

Sam will you take this patch then?

Yours,
Linus Walleij
