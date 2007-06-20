Return-Path: <linux-kernel-owner+w=401wt.eu-S1752936AbXFTVOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936AbXFTVOm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 17:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbXFTVOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 17:14:35 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:50881 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbXFTVOd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 17:14:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=q+hOGkd2NGE/sV8E3VsFyJWn+5dVAAgWkZxxqpfkSx8sEEZHG60C+bJEXd+9HB4rfYuKROOIuSnNoa7dxcZfsAl3z3KkCetIYhjCqPc83WcHw9MxuSGjZvrqWsF4JCH3/a7Rt2+VIepl2NyQ+e+1Sdk5Ef4RbcWUs2PuvKe8ntg=
Message-ID: <2e6659dd0706201414g3a6af30cvfb50720962e9dc1c@mail.gmail.com>
Date: Wed, 20 Jun 2007 18:14:32 -0300
From: "Tomas Neme" <lacrymology@gmail.com>
To: "Alexandre Oliva" <aoliva@redhat.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Cc: "Andrew McKay" <amckay@iders.ca>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Al Viro" <viro@ftp.linux.org.uk>,
       "Bernd Schmidt" <bernds_cb1@t-online.de>, "Ingo Molnar" <mingo@elte.hu>,
       "Daniel Hazelton" <dhazelton@enter.net>, "Greg KH" <greg@kroah.com>,
       "debian developer" <debiandev@gmail.com>, david@lang.hm,
       "Tarkan Erimer" <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <orodjatk8x.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <orabuzkw0i.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <alpine.LFD.0.98.0706171157400.14121@woody.linux-foundation.org>
	 <or3b0qgy8r.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <alpine.LFD.0.98.0706171630150.14121@woody.linux-foundation.org>
	 <orlkeidryp.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <4679557C.5080907@iders.ca>
	 <20070620175627.319a6c55@the-village.bc.nu>
	 <46797C52.4020907@iders.ca>
	 <orodjatk8x.fsf@oliva.athome.lsd.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > However, I don't see how this would ever require a company like Tivo
> > or Mastercard to have their networks play nice with a unit that has
> > been modified by the end user, potentially opening up some serious
> > security holes.
>
> Which is why the GPLv3 doesn't make the requirement that you stated.

Why, if you let user-compiled kernels to run in a TiVo, it might be
modified so the TiVo can be used to pirate-copy protected content,
which is a serious security hole. TiVo would need to read, approve of,
and sign any modified kernels the users intend to use on their
hardware. If GPLv3 allows for this, it'd be doing exactly that

Tomás

-- 
|_|0|_|
|_|_|0|
|0|0|0|
