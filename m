Return-Path: <linux-kernel-owner+w=401wt.eu-S933010AbZJ3Wra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933010AbZJ3Wra (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 18:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932962AbZJ3Wr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 18:47:29 -0400
Received: from mail-vw0-f192.google.com ([209.85.212.192]:60155 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932946AbZJ3Wr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 18:47:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=bYcNMK3crT8E+6zK6bNKQpBflSVpTMOMcRqkHX+VH3d/d20AgiDW7MlkDJuya4VW7r
         fjx/DKgjE+ZzOotrW4maaTZguk69e6dDzJfQKEMz3fAexlg8UOmpcBTO6Jj7YbyqrBmh
         QTKnKJ+FYhiZOZ7P/IZTbQqfOYI7hxWfcE6ZI=
MIME-Version: 1.0
In-Reply-To: <63386a3d0910280131k5043648fu600a223936cd081a@mail.gmail.com>
References: <1255078843-24958-1-git-send-email-linus.walleij@stericsson.com>
	 <e9c3a7c20910121524l5a2207b9h840142c6793dad6e@mail.gmail.com>
	 <63386a3d0910280131k5043648fu600a223936cd081a@mail.gmail.com>
Date: Fri, 30 Oct 2009 15:47:33 -0700
X-Google-Sender-Auth: a2de7afb62bcf256
Message-ID: <e9c3a7c20910301547v5e0d0d81gf7edf5a70ff5b1b4@mail.gmail.com>
Subject: Re: [PATCH] Add COH 901 318 DMA block driver v2
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
       Maciej Sosnowski <maciej.sosnowski@intel.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 28, 2009 at 1:31 AM, Linus Walleij
<linus.ml.walleij@gmail.com> wrote:
> Hi Dan, thanks *a lot* for the review, a v3 version will follow
> shortly, hopefully
> this will be mainline material.

Once Alan's comments are addressed I think it will be.  I'll queue the
eventual v4 up for 2.6.33 given the revised policy of not merging
non-boot-critical drivers outside of the merge window.

Regards,
Dan
