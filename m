Return-Path: <linux-kernel-owner+w=401wt.eu-S1755941AbZDNQoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbZDNQoy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 12:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751512AbZDNQop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 12:44:45 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:44672 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbZDNQoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 12:44:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gWMYpQjeZs7YOlGHi964//T5KGWAkz1hGaeIaJmdccEsn3jRvfeZ1QEWvLu51mceg1
         QJmYyhK11zBld12Dvg5BgKULmdY0uJuSjDc5xGt1V6ExrwYT0bNO4ml9llMZHeS1ASLQ
         +Qy+4W/+7waE9Ckn7efbhaMm0d7vLyQb1S5+s=
MIME-Version: 1.0
In-Reply-To: <20090414080511.5f50a81a@infradead.org>
References: <2d05c4580904140255t25414b2bpe99b2a150dbe132a@mail.gmail.com>
	 <20090414080511.5f50a81a@infradead.org>
Date: Tue, 14 Apr 2009 18:44:43 +0200
Message-ID: <2d05c4580904140944s1dec7dfewf42862ac698bf669@mail.gmail.com>
Subject: Re: Fast testing
From: Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well Arjan it looks that you have a nice laptop if that is your
reboot time :)

The idea about this is that when you have some idea and you
write code, doing reboot and stuff can make you forgot your idea.
If you write normal program you probably press "build" or type
"gcc" at least 10 times to see what is going on. I think that only
thing necessary is: system to boot one time and then you can
load image in ram memory as many times as you want. So I am
not sure if this is ok, but at least I will try.

But I am not saying that if this works, the changes are going to
crush or freeze system more often than produce any kind of result :)

For example, we can boot from GRUB command line, so this would
be something like falling back to GRUB command line [to that point]
and load [any] image in ram memory.

thanks,

Dragoslav Zaric

[Programmer, M.Sc Astrophysics]
