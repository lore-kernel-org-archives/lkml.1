Return-Path: <linux-kernel-owner+w=401wt.eu-S1755907AbZKDTIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbZKDTIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 14:08:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbZKDTIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 14:08:46 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:50115 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbZKDTIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 14:08:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=PWLtEhPgnvz+pB+BMhuu7PhfWuzeC27Vng2/AUpBExeM3QmYHFgovG99SZpxosScIp
         egfDsIdMlGfJtIlwGtFK4I5bWY4HW04+FRG8v/4N4Z7q0LiRQ1bUDFl56VxvtEacsrr8
         KuiePTyrkUW7YKVaCQb9WlUYme7aoJPyWYp4Y=
MIME-Version: 1.0
In-Reply-To: <20091104173305.28463.69600.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
	 <20091104173305.28463.69600.sendpatchset@localhost.localdomain>
Date: Wed, 4 Nov 2009 20:08:50 +0100
Message-ID: <14add3d10911041108u42f0323csdd02fbefa8f4f30f@mail.gmail.com>
Subject: Re: [PATCH 09/41] rt2800usb: add rt2800_register_[read,write]() 
	wrappers
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
> Subject: [PATCH] rt2800usb: add rt2800_register_[read,write]() wrappers
>
> Part of preparations for later code unification.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---

For what it is worth:

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
