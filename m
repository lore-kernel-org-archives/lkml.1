Return-Path: <linux-kernel-owner+w=401wt.eu-S1756479AbZKDSnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479AbZKDSnf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 13:43:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753625AbZKDSne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 13:43:34 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:64629 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbZKDSne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 13:43:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=RD2IyG3XmRn6AaB7dcgJepG/fzOAKwS4joG7qYBGJhccPv5yXgJd5GRrkj9kINTw4g
         UxUSaNV3ZYRZ66NCguD4p9NwhJGrkF6TdPyl1HWSQghUV8MzK1d7Sw2Uh98NhDudDL2t
         omLe3EgY2/mBFS9WR+OZoWzbNZWz7CaBCKlkI=
MIME-Version: 1.0
In-Reply-To: <20091104173250.28463.45273.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
	 <20091104173250.28463.45273.sendpatchset@localhost.localdomain>
Date: Wed, 4 Nov 2009 19:43:39 +0100
Message-ID: <14add3d10911041043g356c8d22nc300383f32c146b4@mail.gmail.com>
Subject: Re: [PATCH 07/41] rt2x00: fix rt2x00usb_register_read() comment
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 4, 2009 at 6:32 PM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2x00: fix rt2x00usb_register_read() comment
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---

For what it is worth:

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
