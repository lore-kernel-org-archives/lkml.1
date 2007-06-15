Return-Path: <linux-kernel-owner+w=401wt.eu-S1756064AbXFONTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbXFONTs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 09:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753838AbXFONTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 09:19:40 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:6556 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781AbXFONTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 09:19:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UowxVFGZhoDQ7IbvdvEgTLMpMllMGO0RrmIOgKDgJaYYUeVe7hSd80lz1wowaqMwyzeTDZtJSgY+ZTVaRHRn6Tcbrh6V0F8BNkdMxA3NOOikKmcKCUUQ++Oy4/cHjuGE/Plv00iymUMT00zJj/14X6GEx10Fgs2/CPJfPMhKbmY=
Message-ID: <d120d5000706150619r238b6c51r8203331a72d16b93@mail.gmail.com>
Date: Fri, 15 Jun 2007 09:19:38 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Cc: "Bernd Paysan" <bernd.paysan@gmx.de>,
       "Alexandre Oliva" <aoliva@redhat.com>,
       "Paulo Marques" <pmarques@grupopie.com>,
       "Al Viro" <viro@ftp.linux.org.uk>, "Krzysztof Halasa" <khc@pm.waw.pl>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070615141923.63fd5cdd@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <466A3EC6.6030706@netone.net.tr>
	 <or4plae61r.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <d120d5000706141155s4e9caceci6958ceceebad6c73@mail.gmail.com>
	 <200706151048.57762.bernd.paysan@gmx.de>
	 <d120d5000706150546k6a31f831tb496bc73bbaa553@mail.gmail.com>
	 <20070615135739.14862d6d@the-village.bc.nu>
	 <d120d5000706150603w2f70431ei5a2ae461ac3d0ff4@mail.gmail.com>
	 <20070615141923.63fd5cdd@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/15/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> O> GPL itself does not. But the author(s) may when they specify "any
> > later version", "dual GPL/BSD", etc. In this case (IMHO) distributor
> > in fact relicenses the code and may reduce license to sipmply BSD or
> > simply GPL, or "GPL v3 from now on". To "restore" license you would
> > need to go upstream and get the code from there.
>
> I don't see anything in the GPL that permits a redistributor to change
> the licence a piece of code is distributed under. If my code is GPL v2 or
> later you cannot take away the "or later" unless explicitly granted
> powers by the author to vary the licence.
>
> What you most certainly can do is modify it and decide your modifications
> are GPLv3 only thus creating a derived work which is GPLv3 only. However
> anyone receiving your modified version and reverting the modifications is
> back at v2 or later.
>

Yes, I agree. When I am saying "distributor" it is someone like RedHat
or TiVO who do modify the code, not merely use it in ints original
form.

-- 
Dmitry
