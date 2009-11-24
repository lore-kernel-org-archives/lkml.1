Return-Path: <linux-kernel-owner+w=401wt.eu-S1753579AbZKXAaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbZKXAaF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 19:30:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbZKXAaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 19:30:04 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:46223 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbZKXAaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 19:30:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=j/yzoRXCEy9UxoyCLqYjqMklH6iLUe8R1IBorccnvzzgllJBoE3pjiIBfst+TZkpcs
         U6o7049b2ZZyDaLDYcT0KKiPFz+bZLtP6unjOSBq+ZcywkWatKcPpruE9WwZtzr6LxWa
         OQXGU7GbEV1hp2yNLY8+IJP9KO5k4ooBSYU00=
MIME-Version: 1.0
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190901EE5BF5@mi8nycmail19.Mi8.com>
References: <AcpsZyWcnPwxPJjOTguzevF7zf1RpA==>
	 <BD79186B4FD85F4B8E60E381CAEE190901EE5BF5@mi8nycmail19.Mi8.com>
Date: Mon, 23 Nov 2009 17:30:07 -0700
X-Google-Sender-Auth: e5548e44a4043d79
Message-ID: <e9c3a7c20911231630q511c2ecap86a70d81c50414e0@mail.gmail.com>
Subject: Re: drivers/dma/mv_xor.c: use resource_size()
From: Dan Williams <dan.j.williams@intel.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 11:02 AM, H Hartley Sweeten
<hartleys@visionengravers.com> wrote:
> Use resource_size() for devm_ioremap.
>
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>
> ---

Hi,

I just happened to see this.  Please cc me on any patches that touch
drivers/dma/.  In general scripts/get_maintainer.pl is your friend.

Thanks,
Dan
