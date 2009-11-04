Return-Path: <linux-kernel-owner+w=401wt.eu-S1758060AbZKDTqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060AbZKDTqQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 14:46:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757994AbZKDTqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 14:46:15 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:59260 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757916AbZKDTqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 14:46:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=DuTluKrDqy4799eRr0GN6O1fn0IhMd6bfnv8qE3wgCbcKKX/heLuWzJWtZV6zcQKbn
         VBatim0QUckWWF4i+1Rx5fHI5L1TfZO0CKRN7QiSRdAtbYnyP2K+ILFImC/mhvLH4ksQ
         b8W9cfohLJDbJ9OqOLKm6wVKPOcrNDI16DV80=
MIME-Version: 1.0
In-Reply-To: <20091104173418.28463.79825.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
	 <20091104173418.28463.79825.sendpatchset@localhost.localdomain>
Date: Wed, 4 Nov 2009 20:46:20 +0100
Message-ID: <14add3d10911041146wfe3928bu797e3d30fab7b7fc@mail.gmail.com>
Subject: Re: [PATCH 19/41] rt2800usb: add rt2800_rf_[read,write]() wrappers
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
> Subject: [PATCH] rt2800usb: add rt2800_rf_[read,write]() wrappers
>
> Part of preparations for later code unification.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---

For what it is worth:

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
