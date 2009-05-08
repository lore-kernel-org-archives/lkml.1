Return-Path: <linux-kernel-owner+w=401wt.eu-S1763677AbZEHOIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763677AbZEHOIu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 10:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761259AbZEHOES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 10:04:18 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:34583 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760543AbZEHOEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 10:04:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=txQ5TwVPnfWT9R4VnoFYt7n/MxoJTqg84rvTgAfjIaOoUmnII5YJPVXDvbnRJhpi3A
         /XV5MMuMhPi+CpUxuWPA6zVpSLRvydlr6AZsFGd8Qf9OggbH47eCL4/SsjLul/V8ERmz
         b59fTTLZhP6qKN8IVSzyWCLsjzDp2b1+Lv28A=
MIME-Version: 1.0
In-Reply-To: <200905041632.28026.arnd@arndb.de>
References: <cover.1241105648.git.arnd@arndb.de>
	 <10f740e80905030417m3b67da38uecd6bd008b4c7e3f@mail.gmail.com>
	 <200905041632.28026.arnd@arndb.de>
Date: Fri, 8 May 2009 16:04:15 +0200
Message-ID: <10f740e80905080704q4d2336b2v8ec851d0c87c6cda@mail.gmail.com>
Subject: Re: [PATCH 00/27] more non-ABI asm-generic headers
From: Geert Uytterhoeven <geert.uytterhoeven@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 4, 2009 at 16:32, Arnd Bergmann <arnd@arndb.de> wrote:
> On Sunday 03 May 2009, Geert Uytterhoeven wrote:
>> On Thu, Apr 30, 2009 at 17:34, Arnd Bergmann <arnd@arndb.de> wrote:
>> > To avoid trouble with quilt mail, I'm now trying
>> > git-format-patch to generate them, hopefully this
>> > works a little better. Can anyone tell me why I can't
>> > add a 'To' header rather than just 'Cc' in
>> > git-format-patch?
>>
>> I always specify the --to with git send-email.
>
> I haven't tried using git send-email yet, because it does not let
> me inspect mails after changing the headers but before sending
> them out.

The --dry-run option is not sufficient for you?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
