Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812AbYJWXiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbYJWXiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 19:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbYJWXhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 19:37:51 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:24465 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbYJWXhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 19:37:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Cht6nqjldNKEHdYyqvaBqbH0QBilWM5h4LDHSqZiow1McXtkCHrhx75ExYnr5EFgX5
         lshJzYlVBbO4zKI7EWV0M3ZbIZXpvg/wh4OcylJCuibzkDIkjr8Y6w7cI8j6e6Wq5Q8s
         j6P2XrKgcCVil+ifm9mmoxyxxTvVxO69kYsUw=
Message-ID: <43e72e890810231637v51591edak5345faccd81d594b@mail.gmail.com>
Date: Thu, 23 Oct 2008 16:37:48 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       otus-devel@venema.h4ckr.net
Subject: Re: Release of Atheros 802.11n USB Linux driver
In-Reply-To: <43e72e890810211904x7bd243dem68dfcfe7a795ec6f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <43e72e890810211904x7bd243dem68dfcfe7a795ec6f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2008 at 7:04 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> We would like to see our Atheros 802.11n USB Linux driver upstream
> however we need help with this so we are releasing our Atheros 11n USB
> Otus Linux driver under the ISC to the community. The goal is to work
> with the community to help move this forward upstream. We are hoping
> for community help and leadership on this (*cough*).
>
> In the meantime users should be able to use this driver and patches
> are welcomed to add newer wireless extension support so users on newer
> kernels can get their devices working. The focus should be upstream
> though :)

So for those of you who want to know which devices to buy

Dlink
    * DWA-160A1

Netgear
    * WNDA3100
    * WN111v2

TP-Link
    * TL-WN821N

We now have on the wiki for the driver too, to help followup progress
on development for this driver.

http://wireless.kernel.org/en/users/Drivers/otus

  Luis
