Return-Path: <linux-kernel-owner+w=401wt.eu-S1757984AbZKDTX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984AbZKDTX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 14:23:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756954AbZKDTX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 14:23:57 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:53237 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295AbZKDTX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 14:23:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=WTNT296zf+jCD/yN+zqsGBFlWG/L93bgI6LSoZQXmdQ8Ns9PDXN8Xx/Fvvgfa5osZn
         zb4E4+M3tpckFkrlJpe8BdZDJeYhfYJb40BWuhDztZxvT7ICUcaD70SJsi8/1mSB8Ep/
         Blqh6K3LnQmXvl1lcjsrHhjiGMTFROz5txaU0=
MIME-Version: 1.0
In-Reply-To: <20091104173341.28463.11122.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
	 <20091104173341.28463.11122.sendpatchset@localhost.localdomain>
Date: Wed, 4 Nov 2009 20:24:01 +0100
Message-ID: <14add3d10911041124j2c011107j13170304324d8f18@mail.gmail.com>
Subject: Re: [PATCH 14/41] rt2800pci: add rt2800_regbusy_read() wrapper
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
> Subject: [PATCH] rt2800pci: add rt2800_regbusy_read() wrapper
>
> Part of preparations for later code unification.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---

For what it is worth:

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
