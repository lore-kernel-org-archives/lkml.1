Return-Path: <linux-kernel-owner+w=401wt.eu-S1757945AbZKDTSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945AbZKDTSj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 14:18:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757827AbZKDTSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 14:18:38 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:58736 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756960AbZKDTSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 14:18:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=gNqM980gEjmnmeE6eomPRydXy1Bizx4ynLgY7K/R9KiTH+sd3JSrmvU8p43NpMNm/o
         6z/8Tln688r8i22Ei9U8RoY/m2vWsZi//ImYTWic1pAJwm2RhV1McNyAexNKnWxqmd+4
         eCVS5kafQ+igYnd+8F2eZg+ggNobaS+AvEl0E=
MIME-Version: 1.0
In-Reply-To: <20091104173320.28463.59233.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
	 <20091104173320.28463.59233.sendpatchset@localhost.localdomain>
Date: Wed, 4 Nov 2009 20:18:42 +0100
Message-ID: <14add3d10911041118u3f0ec41eif0ee1a0421d719db@mail.gmail.com>
Subject: Re: [PATCH 11/41] rt2800usb: add rt2800_register_multi[read,write]() 
	wrappers
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 4, 2009 at 6:33 PM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2800usb: add rt2800_register_multi[read,write]() wrappers
>
> Part of preparations for later code unification.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---

For what it is worth:

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
