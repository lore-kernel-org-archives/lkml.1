Return-Path: <linux-kernel-owner+w=401wt.eu-S1757831AbXFOQb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757831AbXFOQb0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 12:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755190AbXFOQa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 12:30:57 -0400
Received: from qb-out-0506.google.com ([72.14.204.230]:59101 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679AbXFOQaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 12:30:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uqO1ErrEthUdrw1dpzYKgwujcowKiChC5Sn+qZTHBQBl/Wyg5jB+VUwDwX/YE+l71UNaO7fDr7cSYtnTKGu2lgAETDk3G6VevtF6KXmoXzrWnGV/EOZeXK2DLbp6dpPjTdqbB5jgQjBh9jN0nUTTSXIHKa/wZwewfr7BzR30s1M=
Message-ID: <d120d5000706150930g5768f07fw33d9f5ab0275ce9f@mail.gmail.com>
Date: Fri, 15 Jun 2007 12:30:54 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Cc: "Daniel Forrest" <forrest@lmcg.wisc.edu>,
       "Bernd Paysan" <bernd.paysan@gmx.de>,
       "Alexandre Oliva" <aoliva@redhat.com>,
       "Paulo Marques" <pmarques@grupopie.com>,
       "Al Viro" <viro@ftp.linux.org.uk>, "Krzysztof Halasa" <khc@pm.waw.pl>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070615172512.6bdc8418@the-village.bc.nu>
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
	 <20070615100915.A24218@yoda.lmcg.wisc.edu>
	 <20070615172512.6bdc8418@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/15/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > But that begs the question: How do you know what has been modified so
> > you can revert the modifications?  There won't necessarily be any
> > indication of which files have been modified.
>
> There will
>
> 2a) You must cause the modified files to carry prominent notices
>    stating that you changed the files and the date of any change.
>

So how do you deduce what to revert (without going upstream for a
pristine copy) if you see the following notice (I assume it is
prominent enough):
:

/*
 * ATTENTION!!!
 * This file was modified from it's original version on 30-FEB-2345 by XYZ
 */

?

-- 
Dmitry
