Return-Path: <linux-kernel-owner+w=401wt.eu-S934330AbZKYDvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934330AbZKYDvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 22:51:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933840AbZKYDvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 22:51:50 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:62982 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933645AbZKYDvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 22:51:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=sxPTI8CVMD8OA3Gz1QZRf4UyrvutofcIGJc9Sp2qS4lifEOqMcvO1leqt0Hsjxr0ZK
         a2ck0kunXM0/K6tnjebYfo3/e8c2EB9p1IrCTh+qs00HFGKo3iLeSmTGJM6EAs+gEjSJ
         yhsLt5mHIHvNOoEUUIoMG0BYVWZpYz2s2VMqs=
MIME-Version: 1.0
In-Reply-To: <1259148311-31724-1-git-send-email-cliffcai.sh@gmail.com>
References: <1259148311-31724-1-git-send-email-cliffcai.sh@gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 24 Nov 2009 22:51:34 -0500
Message-ID: <8bd0f97a0911241951o5394972dl65c48371f4149b7d@mail.gmail.com>
Subject: Re: [PATCH v2] [mmc/host]:Blackfin SD Host Controller Driver
To: cliffcai.sh@gmail.com
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
       cliff.cai@analog.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 25, 2009 at 06:25,  <cliffcai.sh@gmail.com> wrote:
> From: Cliff Cai <cliffcai.sh@gmail.com>
>
> v2-v1 change:remove mmc host before releasing it in sdh_probe().
>
> Signed-off-by: Cliff Cai <cliffcai.sh@gmail.com>
> ---

changelog info should be below the ---, not above.

you're also missing the s-o-b's:
    Signed-off-by: Bryan Wu <cooloney@kernel.org>
    Signed-off-by: Mike Frysinger <vapier@gentoo.org>
-mike
