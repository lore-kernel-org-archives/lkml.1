Return-Path: <linux-kernel-owner+w=401wt.eu-S1757686AbZKDSWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686AbZKDSWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 13:22:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757559AbZKDSWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 13:22:50 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:35828 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757515AbZKDSWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 13:22:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Ud4wAWT3A7XtabXxbRHs/kfVGZmsRXyj6cjgJEnYGC53+Y/EzxGHnUT8E410zKw2I0
         puMcl170BVKUOXhlj6cUG0vDprIpROJf00QjSI/17xUI36/NgMKxdY6/RCkhtR1S6Rkb
         E/qMOs74IFrLdorhZ2DWdC3RUO4FAb04uyxM4=
MIME-Version: 1.0
In-Reply-To: <20091104173158.28463.66661.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
	 <20091104173158.28463.66661.sendpatchset@localhost.localdomain>
Date: Wed, 4 Nov 2009 19:22:54 +0100
Message-ID: <14add3d10911041022l6f3b0bbdq1f2a58522587ef30@mail.gmail.com>
Subject: Re: [PATCH 01/41] rt2800usb: make Kconfig help entry more helpful
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 4, 2009 at 6:31 PM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2800usb: make Kconfig help entry more helpful
>
> Document known issues with the driver to aid distribution makers,
> users and developers in making informed decisions instead of wasting
> their time needlessly.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
> This reflects the actual state of affairs for driver in Linus' tree.

For what it's worth:

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
