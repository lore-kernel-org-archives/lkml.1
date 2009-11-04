Return-Path: <linux-kernel-owner+w=401wt.eu-S1757854AbZKDSe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757854AbZKDSe1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 13:34:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757802AbZKDSe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 13:34:26 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:46075 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756891AbZKDSeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 13:34:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=d4QBrynVL+WqdQJa+wb1CzMMAGvN7/SuL/6GluM69eu5pdygCqy/qMbY3a9PFAF7Pg
         92Sq4wQ/wPnJE8gG1N2ZI6nWP2HVU+vWemRjL5CMrxlQkn2seCkvnyEP+iQtkussBR5t
         7sHDA4MvXx+pRzOYC+yiLdj8f/e8pMroDpAgA=
MIME-Version: 1.0
In-Reply-To: <20091104173232.28463.47998.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
	 <20091104173232.28463.47998.sendpatchset@localhost.localdomain>
Date: Wed, 4 Nov 2009 19:34:27 +0100
Message-ID: <14add3d10911041034s5a005775x37e15fe4cfd1b4d5@mail.gmail.com>
Subject: Re: [PATCH 05/41] rt2800pci: fix comment about register access
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
> Subject: [PATCH] rt2800pci: fix comment about register access
>
> Registers used for indirect BBP and RF registers access are
> respectively BBPCSR and RFCSR, also make it clear that all CSR
> registers access goes through rt2x00pci_register_[read,write]()
> methods.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---

For what it is worth:

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
