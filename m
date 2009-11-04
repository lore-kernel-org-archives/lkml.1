Return-Path: <linux-kernel-owner+w=401wt.eu-S1757977AbZKDTak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977AbZKDTak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 14:30:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757941AbZKDTaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 14:30:39 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:48444 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756008AbZKDTah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 14:30:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Eru9ly/3jKtqG7FAyddwrC6WLfTyuDppiAlNx0bxWTYsNAK03C4lHUXKCNDqFmjWFX
         R66LbQQR6z393Jd2KGPgDvAJEBdX1hJh+QZg5z04BUunG4b1f8jx3aDvefPHVXfKAGga
         9nSWDk8cVOTuazmKIAhRWrHdMqUSv+ZJsq5A4=
MIME-Version: 1.0
In-Reply-To: <20091104173350.28463.25405.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
	 <20091104173350.28463.25405.sendpatchset@localhost.localdomain>
Date: Wed, 4 Nov 2009 20:30:42 +0100
Message-ID: <14add3d10911041130n318604e4kb6fabb4f8ce58266@mail.gmail.com>
Subject: Re: [PATCH 15/41] rt2800usb: add rt2800_bbp_[read,write]() wrappers
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
> Subject: [PATCH] rt2800usb: add rt2800_bbp_[read,write]() wrappers
>
> Part of preparations for later code unification.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---

For what it is worth:

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
