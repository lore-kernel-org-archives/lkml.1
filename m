Return-Path: <linux-kernel-owner+w=401wt.eu-S1753899AbZG3HbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbZG3HbP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 03:31:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbZG3HbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 03:31:14 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:35576 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbZG3HbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 03:31:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=GRwY+ORMhNCZrB0hHdPOvHsABUTLLrIRLszL2F6RxEvvaNGk29sTnkcuE699aTuceT
         jP0nZIogBzoUnDat6GHXJxKuvHn+eyY/DqXOtQvgf/bJLuqEL86rSzckVkX/vz93PcRA
         BnlGfwHRKaaSXyXEYzG/BqpoBgZ8cXUBpJmEY=
MIME-Version: 1.0
In-Reply-To: <1248932218.27010.8.camel@maxim-laptop>
References: <fdaac4d50907042242s6534d63at12a26df47a0f3b2a@mail.gmail.com> 
	<1248932218.27010.8.camel@maxim-laptop>
From: Jun Koi <junkoi2004@gmail.com>
Date: Thu, 30 Jul 2009 16:01:48 +0900
Message-ID: <fdaac4d50907300001v559610f7ue1fce515e48729a0@mail.gmail.com>
Subject: Re: Firewire debugging tools - firedump & fireproxy?
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>,
       Bernhard Kaindl <bk@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 2:36 PM, Maxim Levitsky<maximlevitsky@gmail.com> wrote:
> On Sun, 2009-07-05 at 14:42 +0900, Jun Koi wrote:
>> Hi,
>>
>> I am doing some debugging via firewire. I found some references to
>> some tools named firedump & fireproxy, made by Bernhard Kaindl,
>> supposed put at following addresses:
>>
>> ftp://ftp.suse.de/private/bk/firewire/tools/firedump-0.1.tar.bz2
>> ftp://ftp.suse.de/private/bk/firewire/tools/fireproxy-0.33.tar.bz2
>>
>> However, these URLs are nolonger available. I am wondering if they
>> have been moved to somewhere else? Anybody know?

> Me having the same question. I have just bought everything for firewire
> debugging.
>
> Jason Wessel, what the fate of kgdbom ?
> (and kgdboe btw ....)
>

These URLs are provided in Documentation/debugging-via-ohci1394.txt,
and not available now. So that should be fixed, or removed, at least.

Thanks,
J
