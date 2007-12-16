Return-Path: <linux-kernel-owner+w=401wt.eu-S932669AbXLPKwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669AbXLPKwd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 05:52:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761753AbXLPKwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 05:52:24 -0500
Received: from py-out-1112.google.com ([64.233.166.180]:5181 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761AbXLPKwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 05:52:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=A0HxCGHfJoIW53Tuf/Nzy78mn+FKQhB7NIYuG77VN5aZMzI6oOxCWeYbtoJ+aw4l4BhiBCnUC5wKTHvLS1IOL52j/a125XfDBm4B3C3X57pRpBcVYmZ4CLKVHJwCCeGKSZWZKySrj5YKLen76SByv8obVRnKv3z8e9H6w+UflbA=
Message-ID: <bc64b4640712160252o6d91a95bm82f735ec876e5dbf@mail.gmail.com>
Date: Sun, 16 Dec 2007 13:52:22 +0300
From: Dmitry <dbaryshkov@gmail.com>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH] Tosa keyboard support
Cc: linux-input@atrey.karlin.mff.cuni.cz,
       "Marcin Juszkiewicz" <openembedded@hrw.one.pl>,
       dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <20071216102911.GA2307@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071211152318.GA8344@doriath.ww600.siemens.net>
	 <20071211153851.GA14156@doriath.ww600.siemens.net>
	 <20071216102911.GA2307@flint.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2007/12/16, Russell King - ARM Linux <linux@arm.linux.org.uk>:
> On Tue, Dec 11, 2007 at 06:38:51PM +0300, Dmitry Baryshkov wrote:
> > Sorry, posted wrong version of patch. Here is correct version:
> >
> > Support keyboard on tosa (Sharp Zaurus SL-6000x).
> > Largely based on patches by Dirk Opfer.
>
> Looks fine to me, but Dmitry Torokhov needs to look at it; he maintains
> the input subsystem.  Note that the current input subsystem mailing list
> is not the one you have in the CC line - please always check MAINTAINERS
> for the correct addresses.
>

Ok, thanks,
resent to linux-input.


-- 
With best wishes
Dmitry
