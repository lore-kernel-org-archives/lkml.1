Return-Path: <linux-kernel-owner+w=401wt.eu-S1758138AbZKDUEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138AbZKDUEO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 15:04:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932233AbZKDUEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 15:04:13 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:62780 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758121AbZKDUEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 15:04:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=GIUE0+H7qPV0skUNUXUL6wAS6UGefz9g8TOObQnmsx8ijhvroh3nkBvCo73T13W+6N
         kqbwIhUvpkOCd/jG/kJB2wYu90f9gUsOv/PrDXT+6CxB4FcNiyZ4VzQgId4agvmrm218
         WPlhm6j75IhoifFzhW+3tPHa/c6dmDhsbubIM=
MIME-Version: 1.0
In-Reply-To: <20091104173525.28463.40807.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
	 <20091104173525.28463.40807.sendpatchset@localhost.localdomain>
Date: Wed, 4 Nov 2009 21:04:17 +0100
Message-ID: <14add3d10911041204n2466290fybf42008ab2061bd6@mail.gmail.com>
Subject: Re: [PATCH 28/41] rt2x00: fix rt2x00pci_register_multi[read,write]() 
	arguments
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 4, 2009 at 6:35 PM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2x00: fix rt2x00pci_register_multi[read,write]() arguments
>
> Change type of 'length' argument from u16 to u32 (all arguments
> match rt2x00usb_register_multi[read,write]() ones now).
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---

For what it is worth:

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
