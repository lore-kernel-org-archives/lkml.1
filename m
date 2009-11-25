Return-Path: <linux-kernel-owner+w=401wt.eu-S934522AbZKYGH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934522AbZKYGH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 01:07:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbZKYGH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 01:07:57 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:60838 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbZKYGH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 01:07:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=DgXSOON1arvVK867H9LsSWcLlfNzWpc9lbvsThc1OHZA8U4bsTiEeQL9nBH9APqbuS
         sI+Ty00PATrW0dgMVuf31rmDqcAj4zM9ldIvDwea+hI/LMzAJEEVFLZJ+lu5vLkgY1Ow
         zELyqhkfe7gRhNZFseBW3+Rq0U7/qejPiPtOE=
MIME-Version: 1.0
In-Reply-To: <1259155212-32369-1-git-send-email-cliffcai.sh@gmail.com>
References: <1259155212-32369-1-git-send-email-cliffcai.sh@gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 25 Nov 2009 01:07:43 -0500
Message-ID: <8bd0f97a0911242207t6facdec7hdbd6af3181bbbbdb@mail.gmail.com>
Subject: Re: [PATCH v3][mmc/host]:Blackfin SD Host Controller Driver
To: cliffcai.sh@gmail.com
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
       cliff.cai@analog.com, Bryan Wu <cooloney@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 25, 2009 at 08:20,  <cliffcai.sh@gmail.com> wrote:
> --- /dev/null
> +++ b/drivers/mmc/host/bfin_sdh.c
> @@ -0,0 +1,634 @@
> +/*
> + * bfin_sdh.c - Analog Devices Blackfin SDH Controller
> + *
> + * Copyright (C) 2009 Analog Device Inc.
> + *
> + * Licensed under the GPL-2 or later.
> + */

any reason you dropped '2007-' ?  we developed the code back then and
certainly have copyright domain over it.
-mike
