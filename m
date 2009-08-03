Return-Path: <linux-kernel-owner+w=401wt.eu-S1752500AbZHCBBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbZHCBBZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 21:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751150AbZHCBBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 21:01:24 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:52496 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbZHCBBX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 21:01:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pRH0N8qhy/6e3hNC5LoezQ8FZ3Lg+TQFGG3Rau64uo11y4TQNZX6gxcqgbAKp0DNuu
         rjS+PlKxgmoNA5mZwYc549pJPYb/QkQiE+iWZIFGc5Pgo+9nuLymFoDCN+Za/i5xZCVO
         WsiFT2g2yJph1iH38b2TPwETmtOZcI8ABBFh0=
MIME-Version: 1.0
In-Reply-To: <7ixSg7D88bK.A.guG.mrgdKB@chimera>
References: <upey9ZSfnaF.A.-oE.rpgdKB@chimera>
	 <7ixSg7D88bK.A.guG.mrgdKB@chimera>
Date: Mon, 3 Aug 2009 03:01:22 +0200
Message-ID: <c62985530908021801r2e302dfel86f69f62143cabc0@mail.gmail.com>
Subject: Re: [Bug #13374] reiserfs blocked for more than 120secs
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Harald Dunkel <harald.dunkel@t-online.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Mahoney <jeffm@suse.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harald,

Does it still happen with 2.6.31-rc5 ?

If so, do you have further informations that could help us reproducing it?

Thanks,
Frederic.

2009/8/2 Rafael J. Wysocki <rjw@sisk.pl>:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.29 and 2.6.30.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13374
> Subject         : reiserfs blocked for more than 120secs
> Submitter       : Harald Dunkel <harald.dunkel@t-online.de>
> Date            : 2009-05-23 8:52 (72 days old)
> References      : http://marc.info/?l=linux-kernel&m=124306880410811&w=4
>                  http://lkml.org/lkml/2009/5/29/389
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
