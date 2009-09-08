Return-Path: <linux-kernel-owner+w=401wt.eu-S1751898AbZIHTXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898AbZIHTXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 15:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbZIHTXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 15:23:47 -0400
Received: from mail-iw0-f175.google.com ([209.85.223.175]:65449 "EHLO
	mail-iw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbZIHTXq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 15:23:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=fhzaUfS/urOa1//UGsci/vGfRcWpAl1d9c8JQO+otfqG2X0afkcxmJxiOIkdI5aAXB
         0VR06OyCQ6xO7fVRmc+UFLteJU+T5nb9kEmheDbD8bURF3z/rjzxudvFw05t99e85mGy
         HSW1AAs+Fs/hOm9YVirdpIGYkAzFv5G7Egejc=
MIME-Version: 1.0
In-Reply-To: <20090905001824.GA18171@kroah.com>
References: <20090905001824.GA18171@kroah.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 8 Sep 2009 12:23:29 -0700
Message-ID: <43e72e890909081223w3e50eee6v438411462a7ed534@mail.gmail.com>
Subject: Re: [Stable-review] [patch 00/71] 2.6.30.6-stable review
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org,
       alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 4, 2009 at 5:18 PM, Greg KH<gregkh@suse.de> wrote:
> This is the start of the stable review cycle for the 2.6.30.6 release.
> There are 71 patches in this series, all will be posted as a response to
> this one.  If anyone has any issues with these being applied, please let
> us know.  If anyone is a maintainer of the proper subsystem, and wants
> to add a Signed-off-by: line to the patch, please respond with it.
>
> These patches are sent out with a number of different people on the Cc:
> line.  If you wish to be a reviewer, please email stable@kernel.org to
> add your name to the list.

I think this automated message needs some updated to reflect the fact
that a mailman list is used now, and redirect people to help
themselves to help us by subscribing to:

http://linux.kernel.org/mailman/listinfo/stable-review

> If you want to be off the reviewer list,
> also email us.

This seems to not be required any more.

> Responses should be made by Sunday, Sept 6, 21:00:00 UTC.  Anything
> Anything received after that time might be too late.

I'm a bit too late, but oh well.

> The whole patch series can be found in one patch at:
>        kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.30.6-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> ------------
>

>  drivers/net/wireless/ar9170/main.c        |    5 +-
>  drivers/net/wireless/iwlwifi/iwl-rfkill.c |   26 +++--
>  drivers/net/wireless/iwlwifi/iwl-sta.c    |   12 +++
>  drivers/net/wireless/rt2x00/rt2x00.h      |    6 +-

>  net/mac80211/agg-tx.c                     |    8 ++

These look good.

Reviewed-by: Luis R. Rodriguez <lrodriguez@atheros.com>

  Luis
