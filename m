Return-Path: <linux-kernel-owner+w=401wt.eu-S1753819AbZFHHaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbZFHHaM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 03:30:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316AbZFHH35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 03:29:57 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:45286 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbZFHH34 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 03:29:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=D0frGv0Zd/psyefLSzesQV4FvxrkERIa2HEMqceejZZJw2VMSmn+ReCHAjnjWMgT5F
         cgik2g13zTRmD1PDkwQ1b5zeBBhkGcUeBh4t7a6xLoLIM6NdQRXSlgjhIOEgGkmag58J
         C5oGW2doHHwnamjPxUqTeaRwqpUhRHU9bmzMY=
MIME-Version: 1.0
In-Reply-To: <D9VoutSOyXP.A.LpH.8Z7KKB@chimera>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>
	 <D9VoutSOyXP.A.LpH.8Z7KKB@chimera>
Date: Mon, 8 Jun 2009 09:29:57 +0200
Message-ID: <38b2ab8a0906080029n5d0e167oc2fc217f19882816@mail.gmail.com>
Subject: Re: [Bug #13328] b44: eth0: BUG! Timeout waiting for bit 00000002 of 
	register 42c to clear.
From: Francis Moreau <francis.moro@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

On Sun, Jun 7, 2009 at 11:52 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me know
> (either way).

I just pulled the 2.6.30-rc8 kernel.

I'm giving it a test during this week and let you know if the bug
comes up again.

-- 
Francis
