Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750918Ab0CDFKU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 00:10:20 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34315 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab0CDFKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 00:10:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=Cr5osNwJPT5vS+MGww7oFeoD4u6OY+fsECCjnpok9gORJ1mMUHyHvCKqaq6xntdcxS
         Wu3370OK6jzA0iiN96uRIetQO0kNRZsCN5HoQjeO52esvE0XwQnvWmflNgAPixODwjSR
         yZf7TMdVPulDcUCbq4MODOD4zdKiQQ/3GQE28=
MIME-Version: 1.0
In-Reply-To: <1267664353.10407.1960.camel@localhost.localdomain>
References: <43e72e891003031643u353c72dcj23bf429363a16ec8@mail.gmail.com> 
	<1267664353.10407.1960.camel@localhost.localdomain>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 3 Mar 2010 21:09:55 -0800
Message-ID: <43e72e891003032109v59f1ff52odb60de6111cfec53@mail.gmail.com>
Subject: Re: Linux Bluetooth Coexistence documentation in general and for 
	ath9k
To: Bastien Nocera <hadess@hadess.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-bluetooth <linux-bluetooth@vger.kernel.org>,
       linux-kernel@vger.kernel.org,
       "Kevin Hayes\" <kevin@atheros.com>, \"Dan Tian\"" 
	<Dan.Tian@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 3, 2010 at 4:59 PM, Bastien Nocera <hadess@hadess.net> wrote:
> On Wed, 2010-03-03 at 16:43 -0800, Luis R. Rodriguez wrote:
>> Marcel, a question for you below.
>>
>> The question of Bluetooth coexistence pops up here, on IRC and on bug
>> reports quite too often so I've stuffed what I could onto a page with
>> a few references / code and about ath9k's schemes for BT coexistence,
>> feel free to extend or correct:
> <snip>
>> I do wonder if this could be useful to network applets like network
>> manager/connman.
>
> Not really. To me, it sounds like a "make it work" button. The kernel
> bits of Bluetooth should already have an idea of when a device is
> connected, so the kernel should be able to "do the right thing".
>
> Having options over what "the right thing" is is probably a good idea
> whilst the kinks are worked out from the default behaviour, but this is
> not something that should be advertised to users.

I wasn't really thinking of buttons for BT coex, but instead just
information exposed out and making it available. Reason for this is
users tend to be blind about btcoex stuff and it would be nice if we
had a way to inform the user of the btcoex mechanisms that actually
are being used. Does that change your answer?

  Luis
