Return-Path: <linux-kernel-owner+w=401wt.eu-S1758142AbZJGHH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142AbZJGHH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 03:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756715AbZJGHHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 03:07:25 -0400
Received: from mail-qy0-f202.google.com ([209.85.221.202]:35220 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755579AbZJGHHY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 03:07:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rTdVBhf5THygVMUfUNjYibkP6anQ9fLJiF/sWbh0qz9Pd8dOODJWyQvLeO03i7gbgO
         n4HH3uFZnHkXtKb5EMLGHA14W14r77xgOujsKPOxOVGB0dnefGB+vqsla4PyoAgiTTKX
         RY5/aMGxFL3UtkqQd0gIb7rea5CMRSJxGDqKc=
MIME-Version: 1.0
In-Reply-To: <20091007061805.GA7592@july>
References: <20091007061805.GA7592@july>
Date: Wed, 7 Oct 2009 12:36:47 +0530
Message-ID: <5d5443650910070006s1aae5fecmec9f6a24a2e272c5@mail.gmail.com>
Subject: Re: [PATCH 3/6] Haptic: Add haptic maintainer
From: Trilok Soni <soni.trilok@gmail.com>
To: Kyungmin Park <kyungmin.park@samsung.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 7, 2009 at 11:48 AM, Kyungmin Park
<kyungmin.park@samsung.com> wrote:
> Add me to haptic class maintainer
>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  MAINTAINERS |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 09a2028..906b603 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2287,6 +2287,13 @@ F:       Documentation/isdn/README.gigaset
>  F:     drivers/isdn/gigaset/
>  F:     include/linux/gigaset_dev.h
>
> +HAPTIC SUBSYSTEM
> +M:     Kyungmin Park <kyungmin.park@samsung.com>
> +L:     linux-input@vger.kernel.org

Dmitry,

Are you OK if we use linux-input for haptics class patches? OR else we
will just use linux-kernel.


-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
