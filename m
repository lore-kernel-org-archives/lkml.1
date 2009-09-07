Return-Path: <linux-kernel-owner+w=401wt.eu-S1752769AbZIGVcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbZIGVcE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 17:32:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbZIGVcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 17:32:03 -0400
Received: from mail-iw0-f204.google.com ([209.85.223.204]:56999 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbZIGVcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 17:32:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=dyCvkOvbzHYiGG2pGNlsf9CdHNwEnlxFdFqE3vrOZALGLgYo+94jBGfG0ooHBQA+4n
         eE/Mb/NNJKxuJLw/et7Ynzksp6XMCKS+zSNNRSVHrZWw0EEMseei670jTmTCyUJh/eVz
         AR4GncGwNDhCWHoyw+rJJzCZNTDPtNr/dlRHc=
MIME-Version: 1.0
In-Reply-To: <1252348470.3394.30.camel@Joe-Laptop.home>
References: <43e72e890909031554v1343bcfdu8ed6e23d0b1df832@mail.gmail.com> 
	<1252259950.9660.179.camel@Joe-Laptop.home> <43e72e890909061226w743e84e6p17fe0d097316678e@mail.gmail.com> 
	<1252348470.3394.30.camel@Joe-Laptop.home>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 7 Sep 2009 14:31:43 -0700
Message-ID: <43e72e890909071431t2a9ece28u1d5b69dd73b1fe15@mail.gmail.com>
Subject: Re: [PATCH V2] MAINTAINERS: Add Atheros Linux wireless drivers home 
	page
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       Len Widra <Len.Widra@atheros.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Nick Kossifidis <mickflemm@gmail.com>,
       Bob Copeland <me@bobcopeland.com>, Greg KH <greg@kroah.com>,
       Stephen Chen <Stephen.Chen@atheros.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Senthil Balasubramanian <senthilkumar@atheros.com>,
       Jiri Slaby <jirislaby@gmail.com>, Jouni Malinen <jmalinen@atheros.com>,
       Sujith Manoharan <Sujith.Manoharan@atheros.com>,
       Vasanthakumar Thiagarajan <vasanth@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 7, 2009 at 11:34 AM, Joe Perches<joe@perches.com> wrote:
> On Sun, 2009-09-06 at 12:26 -0700, Luis R. Rodriguez wrote:
>> On Sun, Sep 6, 2009 at 10:59 AM, Joe Perches<joe@perches.com> wrote:
>> > On Thu, 2009-09-03 at 15:54 -0700, Luis R. Rodriguez wrote:
>> >> I'm pleased to announce the new home page to Atheros Linux wireless drivers:
>> >> http://wireless.kernel.org/en/users/Drivers/Atheros
>> > Perhaps add this to MAINTAINERS?
>> Fine by me, except ath5k and ath9k also have their own respective page
>> so those can also be added.
>
> (cc's trimmed and maintainers added)
>
> Perhaps this instead:
>
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Luis R. Rodriguez

think you have to send this to John.

  Luis
