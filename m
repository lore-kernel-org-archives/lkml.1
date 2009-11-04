Return-Path: <linux-kernel-owner+w=401wt.eu-S1758023AbZKDTzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023AbZKDTzF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 14:55:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755413AbZKDTzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 14:55:03 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:54592 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295AbZKDTzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 14:55:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=IiLHXYvYvWI8rlU95CkQFypMbS6n4n+Mh5pT0fCL+l1ey1D4hSOP52CHUpauwtTPjG
         5w00EESyXQWcSmbIkuz4KgTx5dkiXz5VimeTz+JW8LQzQ2vmss7POFF9Hdl2/MODE4NA
         S2OHGA/yXXYHiOd3labxg1RM1p0JP+kXO5u2I=
MIME-Version: 1.0
In-Reply-To: <20091104173446.28463.62662.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
	 <20091104173446.28463.62662.sendpatchset@localhost.localdomain>
Date: Wed, 4 Nov 2009 20:55:06 +0100
Message-ID: <14add3d10911041155x281027fbr58baff49d3d607ba@mail.gmail.com>
Subject: Re: [PATCH 23/41] rt2x00: add driver private field to struct 
	rt2x00_dev
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
> Subject: [PATCH] rt2x00: add driver private field to struct rt2x00_dev
>
> Enhance rt2x00 infrastructure by adding driver specific field to
> struct rt2x00_dev.
>
> The new field will be used by rt2800 drivers for chipset registers
> access abstraction layer.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---

For what it is worth:

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
