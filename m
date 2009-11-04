Return-Path: <linux-kernel-owner+w=401wt.eu-S1758117AbZKDT7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117AbZKDT7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 14:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757998AbZKDT7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 14:59:18 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:60309 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413AbZKDT7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 14:59:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Us/JuXItnSg41gG/t9dziFMXWHDYMwzKUPcIWUWSGZI8QEIxod1yGuxMtL733E9ECT
         ekxrKJD30JCqocMspYs8efwTydDkUQ6k4zK8LIJz6qPq7kdsHFuXVAkZutKhIXtVKtev
         2U0Fuz9g1Uf0vd4+iij8T/nGGsApRh7ryZWr4=
MIME-Version: 1.0
In-Reply-To: <20091104173510.28463.24779.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
	 <20091104173510.28463.24779.sendpatchset@localhost.localdomain>
Date: Wed, 4 Nov 2009 20:59:22 +0100
Message-ID: <14add3d10911041159x78ff5e12ta3d787c502836276@mail.gmail.com>
Subject: Re: [PATCH 26/41] rt2x00: fix rt2x00usb_register_multiwrite() 
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
> Subject: [PATCH] rt2x00: fix rt2x00usb_register_multiwrite() arguments
>
> Add const to 'value' argument of rt2x00usb_register_multiwrite()
> (all arguments match rt2x00pci_register_multiwrite() ones now).
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---

For what it is worth:

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
