Return-Path: <linux-kernel-owner+w=401wt.eu-S1757789AbZKDSaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789AbZKDSaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 13:30:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757678AbZKDSaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 13:30:07 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:37181 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757650AbZKDSaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 13:30:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=wG9W/zbfrxg8WQtx9Z/oRkXLoM1R71IB/N/Fbd2lHRPlELgzxXGAdeLDib0hb5clET
         BeTAn5TaFbpqhfMh69Oi+v/7zs6IC4t8EvmU8POOSEW7i3oIMgkumkwC/6mM0n6hbUiA
         6Qy4y+syrxPEi61BCm6UW2dbuXJnuwHo2WN90=
MIME-Version: 1.0
In-Reply-To: <20091104173224.28463.49296.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
	 <20091104173224.28463.49296.sendpatchset@localhost.localdomain>
Date: Wed, 4 Nov 2009 19:30:10 +0100
Message-ID: <14add3d10911041030j4bd7224ao9373fee4ec7b79c4@mail.gmail.com>
Subject: Re: [PATCH 04/41] rt2800pci: fix crypto in TX frame
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
> Subject: [PATCH] rt2800pci: fix crypto in TX frame
>
> Based on rt2800usb patch from Benoit PAPILLAULT
> (commit 17616310836ad2cc45a64576ef0e1520b0dcc81b).
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---

For what it is worth:

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
