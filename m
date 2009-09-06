Return-Path: <linux-kernel-owner+w=401wt.eu-S1757994AbZIFPHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994AbZIFPHM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 11:07:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757975AbZIFPHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 11:07:10 -0400
Received: from mail-pz0-f192.google.com ([209.85.222.192]:58242 "EHLO
	mail-pz0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbZIFPHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 11:07:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type;
        b=fAMzqaDPdKKwXIQRr3YTjMis4vZ8Bd3qNpr+em6TxsM+NabUmhiqGEj4cDHdlu1d02
         0OM4te5L6n1/9XGrgNEVF2KZaHgWKyn+DY7tH1+1OccOVUc0VzskmZgp3uthIPiza5PT
         ANbIb5gQHi2ZgDTd5jQSl2BlBTtnUdKLKTCxY=
MIME-Version: 1.0
Date: Sun, 6 Sep 2009 17:07:11 +0200
X-Google-Sender-Auth: 19dd9ed067048e47
Message-ID: <10f740e80909060807g11a29730wc809c08efbe4f216@mail.gmail.com>
Subject: [IMPORTANT] linux-fbdev is moving to kernel.org
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-fbdev-devel@lists.sourceforge.net,
       linux-fbdev-users@lists.sourceforge.net
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

The linux-fbdev mailing lists (linux-fbdev-devel and
linux-fbdev-users) are being
migrated from SourceForge.net to a single mailing list at kernel.org
(Thanks David!).

Your subscriptions to the old mailing lists are not automatically
transfered to the new mailing list.To subscribe to the new linux-fbdev
mailing list, please send an email to majordomo@vger.kernel.org with
the following command in the body of your email message:

    subscribe linux-fbdev

In about a week from now, I'll setup auto-responders on the old
mailing lists, to redirect people to the new mailing list.

Sorry for any inconvenience this may cause.

I haven't arranged archives of the new mailing list yet. I also
haven't send a patch to Linus to update MAINTAINERS. I will do that in
the coming days.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
