Return-Path: <linux-kernel-owner+w=401wt.eu-S1752223AbZI1AqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223AbZI1AqY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 20:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbZI1AqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 20:46:24 -0400
Received: from mail-yw0-f174.google.com ([209.85.211.174]:47602 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbZI1AqX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 20:46:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=sGqf6Cej9eu0Wlwci7fc/qSCx8o3v5LGZ3qWVkfJVJGuh+i1XIfbL1QkwA15Sz7lJI
         mzCYPjyG9/OLii4SL2xtSgV5iVTGSf4thLDUIhOGMUe0os00KxG5Y8sonvLJkZXtLfnC
         Q3gOFYB9MSSvRt6nTlofvwAtiPYscBsaJdBN0=
MIME-Version: 1.0
In-Reply-To: <20090927220459.GA13116@x200>
References: <20090927184201.GA12402@x200> <20090927220459.GA13116@x200>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sun, 27 Sep 2009 20:46:07 -0400
Message-ID: <8bd0f97a0909271746o6d9de260p5231d1762f9cd6e5@mail.gmail.com>
Subject: Re: [PATCH] const: constify remaining file_operations
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 27, 2009 at 18:04, Alexey Dobriyan <adobriyan@gmail.com> wrote:
>  arch/blackfin/mach-bf561/coreb.c           |    2 -
>  drivers/char/bfin-otp.c                    |    2 -

these look fine to me, thanks
Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
