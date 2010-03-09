Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab0CIQP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 11:15:29 -0500
Received: from mail-qy0-f179.google.com ([209.85.221.179]:40193 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab0CIQP1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 11:15:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Nyw3bfTsYVN+xGTRygjJbyXRTyuNu91IrkCOoeUnlAX/OVSvh7d4xuU2P9DipUeM6M
         x9nh0s0J7prvT0xWJkFOdxY6QWjedY4avhi4ZKXECHHrgaRverfjb3rX8tE+OxWqM/Cd
         b3QuMYU8BlUk1s9aJmoMwY2ptFJmMERPuRa+w=
MIME-Version: 1.0
In-Reply-To: <8bd0f97a1003090644p19fb7dacqe1f2fb3adee3fa7a@mail.gmail.com>
References: <20100301080342.GH765@core.coreip.homeip.net> <8bd0f97a1003090644p19fb7dacqe1f2fb3adee3fa7a@mail.gmail.com>
From: Cory Maccarrone <darkstar6262@gmail.com>
Date: Tue, 9 Mar 2010 08:15:06 -0800
Message-ID: <6cb013311003090815o7ec1de7fna68150e469855ce5@mail.gmail.com>
Subject: Re: [git pull] Input updates for 2.6.34-rc0
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Robin Getz <rgetz@blackfin.uclinux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 9, 2010 at 6:44 AM, Mike Frysinger <vapier.adi@gmail.com> wrote:
> On Mon, Mar 1, 2010 at 03:03, Dmitry Torokhov wrote:
>> Hi Linus,
>>
>> Please pull from:
>>
>>        git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
>> or
>>        master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus
>>
>> to receive first round of updates for the input subsystem.
>
> i'm trying to figure out what the problem is with the ADXL34x and
> AD714x drivers you seem to have accepted (at least, you didnt say
> there was anything left for us to do).  i would have expected them to
> be in 2.6.33/2.6.34 already, but it seems they arent moving now.  so
> what's up ?
> -mike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

I'm in the same boat with my TSC2046 driver.  Any idea why this hasn't
moved?  I have received no comments, nor has the driver been included
/ accepted.  Do I need to make revisions, or can it be included?

- Cory
