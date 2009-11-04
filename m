Return-Path: <linux-kernel-owner+w=401wt.eu-S1758067AbZKDTq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067AbZKDTq6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 14:46:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758018AbZKDTq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 14:46:57 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:35053 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757994AbZKDTq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 14:46:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=kODuKROsg7yN5jmHJQz2qNCkZ22i3mihe4Xciem3Ys5HAAfAhMtzKkdlw/49Byvl8E
         clr8keTF9Y1lJJzws27wi0h8nt/XQRNGURMtessSmvPslL3oIubq2ktP16rItgf7Ltnu
         P97ZXbX7PC6XUwzUz4mm2JW7+x8odj4mQukog=
MIME-Version: 1.0
In-Reply-To: <20091104173425.28463.74288.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
	 <20091104173425.28463.74288.sendpatchset@localhost.localdomain>
Date: Wed, 4 Nov 2009 20:47:02 +0100
Message-ID: <14add3d10911041147v7016eb8egd73e8d2c3bb2f554@mail.gmail.com>
Subject: Re: [PATCH 20/41] rt2800pci: add rt2800_rf_[read,write]() wrappers
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
> Subject: [PATCH] rt2800pci: add rt2800_rf_[read,write]() wrappers
>
> Part of preparations for later code unification.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---

For what is is worth:

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
