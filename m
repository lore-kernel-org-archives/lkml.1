Return-Path: <linux-kernel-owner+w=401wt.eu-S1756500AbXFONDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500AbXFONDi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 09:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754189AbXFOND3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 09:03:29 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:62471 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605AbXFOND2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 09:03:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=t+dbyOcx2y1G3oJneURj3zAhV+6QiZDPFj+BcRNvPFM8QBnF6ZnwS9+WaZ3IC9B9m6F1alcKzwEBVRBPba/vm3W5AlvfwAYVS8bPs8nnNXcg7LF96+5bwsTixzXL3/ovrfOBa2KO7J5XVMDbzQaVwv951iVoLidsFVb5YiagUas=
Message-ID: <d120d5000706150603w2f70431ei5a2ae461ac3d0ff4@mail.gmail.com>
Date: Fri, 15 Jun 2007 09:03:27 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Cc: "Bernd Paysan" <bernd.paysan@gmx.de>,
       "Alexandre Oliva" <aoliva@redhat.com>,
       "Paulo Marques" <pmarques@grupopie.com>,
       "Al Viro" <viro@ftp.linux.org.uk>, "Krzysztof Halasa" <khc@pm.waw.pl>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070615135739.14862d6d@the-village.bc.nu>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/15/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > No, you do receive the license from the person or entity you received
> > the program. You have an _option_ to go to the original author and get
> > copy of original code with original license (or maybe other license).
>
> You receive the licence from the original author. The GPL contains no
> text allowing a third party to grant new licences.
>

GPL itself does not. But the author(s) may when they specify "any
later version", "dual GPL/BSD", etc. In this case (IMHO) distributor
in fact relicenses the code and may reduce license to sipmply BSD or
simply GPL, or "GPL v3 from now on". To "restore" license you would
need to go upstream and get the code from there.

-- 
Dmitry
