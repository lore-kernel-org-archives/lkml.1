Return-Path: <linux-kernel-owner+w=401wt.eu-S932340AbZKDUV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340AbZKDUV1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 15:21:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932292AbZKDUV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 15:21:27 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:52557 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932244AbZKDUV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 15:21:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=pNHHyo6L3L+E9gABxZr5mO9TJW2VC4AHpx4m3K3KSfv82joeb1G/pOxokUzvnBfYxu
         ReNbfdVoiHLgG/kde4h4fwLwJCJZ2jFd0IZR5Kzq+zrOY1w3orBS4L5HJWPgZZPg2zex
         jHCnjiysMeejJFhQcL6vknftAm/vE6aYrosD8=
MIME-Version: 1.0
In-Reply-To: <20091104173439.28463.20951.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
	 <20091104173439.28463.20951.sendpatchset@localhost.localdomain>
Date: Wed, 4 Nov 2009 21:21:27 +0100
Message-ID: <14add3d10911041221h683e324dp40226f0a5f827358@mail.gmail.com>
Subject: Re: [PATCH 22/41] rt2800pci: add rt2800_mcu_request() wrapper
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
> Subject: [PATCH] rt2800pci: add rt2800_mcu_request() wrapper
>
> Part of preparations for later code unification.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---

For what it is worth:

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
