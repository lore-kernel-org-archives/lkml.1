Return-Path: <linux-kernel-owner+w=401wt.eu-S1760812AbYA1OU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760812AbYA1OU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 09:20:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755222AbYA1OUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 09:20:16 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:33765 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166AbYA1OUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 09:20:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=wm3CeKxDAopw+qSfWG3AivXEWn9qw3tRU0WhfVP8LZrZoqz1JQcIyofUocyNNBlXrbLLAChq5T5aCnIXOjsQcuNSuMkof3PPf4XAp0/0+1UZSdwuOf7ZbdmvUxYTzvcU+rNENQWEl1bZMLa4xFWcPZDAkEm1uNdExXxkQXU9t7M=
Message-ID: <9e4733910801280620t16ceb391vcc8e10ba6bbea183@mail.gmail.com>
Date: Mon, 28 Jan 2008 09:20:13 -0500
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: [GIT PULL] i2c updates for 2.6.25
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux I2C" <i2c@lm-sensors.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080128104348.0f6925f6@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080127182741.62bfe92a@hyperion.delvare>
	 <9e4733910801270936q7affdee3o3518c2265acaf61d@mail.gmail.com>
	 <20080128104348.0f6925f6@hyperion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/28/08, Jean Delvare <khali@linux-fr.org> wrote:
> Hi Jon,
>
> On Sun, 27 Jan 2008 12:36:03 -0500, Jon Smirl wrote:
> > On 1/27/08, Jean Delvare <khali@linux-fr.org> wrote:
> > > Linus,
> > >
> > > Please pull the i2c subsystem updates for Linux 2.6.25 from:
> > >
> > > git://jdelvare.pck.nerim.net/jdelvare-2.6 i2c-for-linus
> >
> > The support for modalias loading of i2c modules isn't in here, what's
> > the status?
>
> The status is that I want to give people some time to comment on my
> modalias patches before I merge them. I also didn't have the time to
> look into the latest patches you sent yet, and I'd rather merge
> everything at once. So the merge window for this is rather 2.6.26.

Delaying these until 2.6.26 which won't be final until 2009 forces us
to ship boxes using a private kernel. These patches have been around
since November. Does it really take over a year to get these changes
in?

>
> --
> Jean Delvare
>


-- 
Jon Smirl
jonsmirl@gmail.com
