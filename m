Return-Path: <linux-kernel-owner+w=401wt.eu-S1758078AbZKDTsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078AbZKDTsX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 14:48:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758033AbZKDTsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 14:48:22 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:34179 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413AbZKDTsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 14:48:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=G2D2ojeHsDLgupPz+5yHkikj/Xk+ZqGqFYv/HXuvxbo7k2S5UCo/jc0mLlfuYT08R5
         yQyFYwF2rWWt9M+edw3GpWc+jxhVlBL0+gzEUp2nT0tdrOca8X3g7SufiSjoM9Q3icNB
         SoubQGtTjofZusev0NgeRHsvvwybrJF7ac2/s=
MIME-Version: 1.0
In-Reply-To: <20091104173432.28463.51210.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
	 <20091104173432.28463.51210.sendpatchset@localhost.localdomain>
Date: Wed, 4 Nov 2009 20:48:26 +0100
Message-ID: <14add3d10911041148i293eef1ake2488bceb9a61b25@mail.gmail.com>
Subject: Re: [PATCH 21/41] rt2800usb: add rt2800_mcu_request() wrapper
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
> Subject: [PATCH] rt2800usb: add rt2800_mcu_request() wrapper
>
> Part of preparations for later code unification.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---

For what it is worth:

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
