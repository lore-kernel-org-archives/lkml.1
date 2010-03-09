Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab0CIOvU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 09:51:20 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38825 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab0CIOvS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 09:51:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=CTv/xm2crbIP8SrbCQ+8d9YJQEq/ZK80cNR19uQS+b9t0BEI8TIrab9ZOhCAFxHMj9
         eHeEuVdMUYH4oWiMBWgE4BiZp5fDp9iGej2z1rx9+VQ1nR4CKiOksaHQjv/JnidwrJ+t
         bbmigByyT9YX7RURDcEynS2RBO7FI2iuCz3g8=
MIME-Version: 1.0
In-Reply-To: <20100301080342.GH765@core.coreip.homeip.net>
References: <20100301080342.GH765@core.coreip.homeip.net>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 9 Mar 2010 09:44:08 -0500
Message-ID: <8bd0f97a1003090644p19fb7dacqe1f2fb3adee3fa7a@mail.gmail.com>
Subject: Re: [git pull] Input updates for 2.6.34-rc0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Robin Getz <rgetz@blackfin.uclinux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 1, 2010 at 03:03, Dmitry Torokhov wrote:
> Hi Linus,
>
> Please pull from:
>
>        git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
> or
>        master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus
>
> to receive first round of updates for the input subsystem.

i'm trying to figure out what the problem is with the ADXL34x and
AD714x drivers you seem to have accepted (at least, you didnt say
there was anything left for us to do).  i would have expected them to
be in 2.6.33/2.6.34 already, but it seems they arent moving now.  so
what's up ?
-mike
