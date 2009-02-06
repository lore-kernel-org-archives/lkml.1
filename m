Return-Path: <linux-kernel-owner+w=401wt.eu-S1758273AbZBFCbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273AbZBFCbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 21:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189AbZBFCbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 21:31:07 -0500
Received: from wf-out-1314.google.com ([209.85.200.170]:35032 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbZBFCbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 21:31:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=yBeMs13bTzzlIhpZMqkwBvAkzMwuT+mHGNRBLH68Ylc3DwMzJoZr12VJe6uFB+fjUs
         qD8jQZlTdq7O3Ok2l7CXIYEd4ad9VmlYEedO4ECWrdv01ywaWbqn7dP/Bj60/ZXLqi28
         EyKCdZWZUmys7hXZG7HJZanzKOep9+XDiABWQ=
MIME-Version: 1.0
In-Reply-To: <200902051551.14146.david-b@pacbell.net>
References: <1226994760-4301-1-git-send-email-cooloney@kernel.org>
	 <200811201405.06811.david-b@pacbell.net>
	 <386072610902050130k27c6d7far752ac49183bf36ae@mail.gmail.com>
	 <200902051551.14146.david-b@pacbell.net>
Date: Fri, 6 Feb 2009 10:31:05 +0800
X-Google-Sender-Auth: 894e7286b36b379a
Message-ID: <386072610902051831k7b3530b1lc19a07b4a0e1eacc@mail.gmail.com>
Subject: Re: [PATCH 01/16] Blackfin SPI Driver: ensure cache coherency before 
	doing DMA
From: Bryan Wu <cooloney@kernel.org>
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mike Frysinger <vapier.adi@gmail.com>,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Vitja Makarov <vitja.makarov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 6, 2009 at 7:51 AM, David Brownell <david-b@pacbell.net> wrote:
> On Thursday 05 February 2009, Bryan Wu wrote:
>> As you acked this patchset, is that possible to merge it?
>> Or need Andrew to keep them in -mm for a while.
>
> ISTR *NOT* acking the whole series though.  In fact, I recall
> giving a generic NAK part way through because of patches that
> didn't include comments (after manually NAKing many individual
> patches) and ones where $SUBJECT didn't match the patch comments.
> Plus even a few which seemed to be wrong.
>
> (And I've said the same thing about Blackfin patches before,
> too.  Please help the message get through to your co-workers:
> make sure the patches come with useful public descriptions.)
>
> At this point, best to resend the whole series, with the
> updates I requested.  The few patches which I did ack can
> include that ack.
>

OK, I will resend these 16 patches and next new 5 patches soon.
Thanks a lot

-Bryan
