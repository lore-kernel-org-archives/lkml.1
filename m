Return-Path: <linux-kernel-owner+w=401wt.eu-S1756663AbZLCTBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663AbZLCTBH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 14:01:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756622AbZLCTBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 14:01:06 -0500
Received: from mail-ew0-f210.google.com ([209.85.219.210]:49854 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756578AbZLCTBA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 14:01:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=QJV+zeK2pXv7DV8U1hLGqGZp7XycqoNFlV2A1F5nqF7IVnzzs2tUm/RqNCLdnI94bW
         nlpXteXkQBI5mnMDo+xXQ3AGMissy7CJG/cSUKNKvHGIPydqsExSsa+ToGtwKO9Pc5GE
         29al0xnsRHP+XBnJ6QNhaGJYOZB7AHhXkLojE=
MIME-Version: 1.0
In-Reply-To: <10f740e80909060807g11a29730wc809c08efbe4f216@mail.gmail.com>
References: <10f740e80909060807g11a29730wc809c08efbe4f216@mail.gmail.com>
Date: Thu, 3 Dec 2009 20:01:05 +0100
X-Google-Sender-Auth: 0381d59ebec4c391
Message-ID: <10f740e80912031101i58cf9495tb5e9e6f2a43f3b3d@mail.gmail.com>
Subject: Re: [IMPORTANT] linux-fbdev is moving to kernel.org
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-fbdev-devel@lists.sourceforge.net,
       linux-fbdev-users@lists.sourceforge.net,
       linux-fbdev-announce@lists.sourceforge.net
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 6, 2009 at 16:07, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> The linux-fbdev mailing lists (linux-fbdev-devel and
> linux-fbdev-users) are being

and linux-fbdev-announce.

> migrated from SourceForge.net to a single mailing list at kernel.org
> (Thanks David!).
>
> Your subscriptions to the old mailing lists are not automatically
> transfered to the new mailing list.To subscribe to the new linux-fbdev
> mailing list, please send an email to majordomo@vger.kernel.org with
> the following command in the body of your email message:
>
>    subscribe linux-fbdev
>
> In about a week from now, I'll setup auto-responders on the old
> mailing lists, to redirect people to the new mailing list.

Done.

> Sorry for any inconvenience this may cause.
>
> I haven't arranged archives of the new mailing list yet. I also

Done (at MARC, cfr. http://vger.kernel.org/vger-lists.html#linux-fbdev).

Still have to collect and send the mails that were sent before MARC
started archiving.

> haven't send a patch to Linus to update MAINTAINERS. I will do that in
> the coming days.

Done, in 2.6.32.

Let's hope I can start living in a spam-free moderation-less world...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
