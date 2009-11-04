Return-Path: <linux-kernel-owner+w=401wt.eu-S932469AbZKDUWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469AbZKDUWq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 15:22:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932441AbZKDUWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 15:22:44 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:40762 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932372AbZKDUWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 15:22:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=LAnCZ+1wT9TY9mrmHaikJQTJuWA12fuW8Hb+g+jzqFdvebmSOGOf8vyBnWVR6Jhs9n
         25+R/TkpBbws8Hzipc6ycvz0B2rEPyHETJuM3LOyE1uXGam7kLwDgGT+sXKjIDYptmJb
         /IVF0sbDC0/dV82U2Qp/yXYZdQKgUP8HjgWAE=
MIME-Version: 1.0
In-Reply-To: <20091104173453.28463.94062.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
	 <20091104173453.28463.94062.sendpatchset@localhost.localdomain>
Date: Wed, 4 Nov 2009 21:22:46 +0100
Message-ID: <14add3d10911041222n15da2266oecec4dfb406f9f0@mail.gmail.com>
Subject: Re: [PATCH 24/41] rt2800usb: convert to use struct rt2800_ops methods
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 4, 2009 at 6:34 PM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2800usb: convert to use struct rt2800_ops methods
>
> Add chipset registers access abstraction layer and prepare for later
> code unification.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---

For what it is worth:

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
