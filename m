Return-Path: <linux-kernel-owner+w=401wt.eu-S1755413AbXFOOrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413AbXFOOrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 10:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753596AbXFOOrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 10:47:04 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:56587 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753543AbXFOOrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 10:47:02 -0400
Message-ID: <4672A65E.6010607@grupopie.com>
Date: Fri, 15 Jun 2007 15:46:54 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Bernd Paysan <bernd.paysan@gmx.de>, Al Viro <viro@ftp.linux.org.uk>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Krzysztof Halasa <khc@pm.waw.pl>, linux-kernel@vger.kernel.org
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr>	<200706151014.45383.bernd.paysan@gmx.de>	<46727CCF.9030905@grupopie.com>	<200706151403.57178.bernd.paysan@gmx.de>	<4672A231.9000800@grupopie.com> <20070615154522.2a161884@the-village.bc.nu>
In-Reply-To: <20070615154522.2a161884@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> But COPYING *is* the entire text and starts with: "
>> 		    GNU GENERAL PUBLIC LICENSE
>> 		       Version 2, June 1991"
>>
>> so there is no confusion about the version.
> 
> The version of the COPYING file (and the licence document), not of the
> licence on the code.
> 
>>> Wrong.
>> Why do you say "Wrong"? Have you contributed some code to the kernel 
>> thinking that the kernel was "v2 or later", only to find out later that 
>> it wasn't?
> 
> A fair bit of the kernel is probably v2 or later but not all of it and
> that shouldn't really matter as regards the kernel anyway, the GPLv2 only
> bits (if v2 only is a valid status) anchor it.

So we are violently agreeing, then?

This sub-thread started by me showing that:

> $ find -name "*.c" | xargs grep "any later version" | wc -l
> 3138
> $ find -name "*.c" | wc -l
> 9482

This is a somewhat crude measure but it shows that only about 30% of the 
kernel is "v2 or later" and those pieces could be used on some other "v2 
or later" project (including v3). But the kernel as a whole is v2 and my 
point was that the claim that there are just a few "v2 only" files was 
bogus.

-- 
Paulo Marques - www.grupopie.com

"As far as we know, our computer has never had an undetected error."
Weisert
