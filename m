Return-Path: <linux-kernel-owner+w=401wt.eu-S1755126AbXFNSzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126AbXFNSzh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 14:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbXFNSzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 14:55:21 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:19938 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705AbXFNSzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 14:55:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MU1LabzWtAMTR30FQbODcyusyQD7BbhLWIhUI8i5Uvzax9kkZ3ZGefW6m1TMZYNsMHs8x5MdVJ9CU4Lx2QQ27vNnF88od83Vb7pZfV6R32nO838G/TpSU9w1Dt4yzwJMrYO8gQ7qMo4BYMBWhnJ23vvAYOejOGM1amXJdoB0OTo=
Message-ID: <d120d5000706141155s4e9caceci6958ceceebad6c73@mail.gmail.com>
Date: Thu, 14 Jun 2007 14:55:17 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Alexandre Oliva" <aoliva@redhat.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Cc: "Paulo Marques" <pmarques@grupopie.com>, "Al Viro" <viro@ftp.linux.org.uk>,
       "Bernd Paysan" <bernd.paysan@gmx.de>,
       "Krzysztof Halasa" <khc@pm.waw.pl>, linux-kernel@vger.kernel.org
In-Reply-To: <or4plae61r.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <466A3EC6.6030706@netone.net.tr>
	 <200706141023.21624.bernd.paysan@gmx.de>
	 <20070614153935.GO21478@ftp.linux.org.uk>
	 <200706141832.58526.bernd.paysan@gmx.de>
	 <20070614164124.GP21478@ftp.linux.org.uk>
	 <d120d5000706141001o2d00f20cqb4133bf7b9ba11ab@mail.gmail.com>
	 <20070614170902.GQ21478@ftp.linux.org.uk>
	 <467178D3.6010204@grupopie.com>
	 <or4plae61r.fsf@oliva.athome.lsd.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/14/07, Alexandre Oliva <aoliva@redhat.com> wrote:
> On Jun 14, 2007, Paulo Marques <pmarques@grupopie.com> wrote:
>
> > $ find -name "*.c" | xargs grep "any later version" | wc -l
> > 3138
> > $ find -name "*.c" | wc -l
> > 9482
>
> How many of these don't mention version 2?
>

It does not matter. GPL v2 and later can be reduced to v2 by
recepient. Linus did just that so unless individual source file
explicitely carries "and later" it is v2.

-- 
Dmitry
