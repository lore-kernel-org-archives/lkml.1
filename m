Return-Path: <linux-kernel-owner+w=401wt.eu-S1754628AbZKHQvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbZKHQvJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 11:51:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754075AbZKHQvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 11:51:08 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:44363 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750AbZKHQvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 11:51:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=nkRMMexVi2HK09A5Qcfy1aYFo7Il1W5EaCW3EBnKFN/N6ImEUSbcSOvfx9/4oMY2Mo
         zIn/InDDa76MNSyja9434OK0IGm0/aHdFoSTw0FHI04xpDeLb40vNXy7jxMfUhld6gWC
         vvyIwk3mlTVHPEKeNxKlMMeVyLHChoErgsfWw=
MIME-Version: 1.0
In-Reply-To: <20091108161620.GM8742@kernel.dk>
References: <200911072237.01807.czoccolo@gmail.com>
	 <20091108161620.GM8742@kernel.dk>
Date: Sun, 8 Nov 2009 17:51:12 +0100
Message-ID: <4e5e476b0911080851h718b1372r3fc3ff57df873de8@mail.gmail.com>
Subject: Re: [PATCH] cfq-iosched: fix next_rq computation
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 8, 2009 at 5:16 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
>
> Thanks, this is a nice patch! I will apply it to for-2.6.33. Can I added
> your signed-off-by?

Yes, thanks.

Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>

>
> --
> Jens Axboe
>
>
