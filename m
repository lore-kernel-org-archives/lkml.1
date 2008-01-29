Return-Path: <linux-kernel-owner+w=401wt.eu-S933461AbYA2RHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933461AbYA2RHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 12:07:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755327AbYA2RGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 12:06:53 -0500
Received: from qmta03.westchester.pa.mail.comcast.net ([76.96.62.32]:35485
	"EHLO QMTA03.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757661AbYA2RGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 12:06:51 -0500
X-Authority-Analysis: v=1.0 c=1 a=vEPNTaulQc2DmXLr8tIA:9 a=dcaZonj0A3vKbm-pwCjyEK6aJeEA:4 a=v47ZLdibA2YA:10
Message-ID: <479F5D29.1020705@bobjweil.com>
Date: Tue, 29 Jan 2008 12:06:49 -0500
From: rgheck <rgheck@bobjweil.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Daniel Barkalow <barkalow@iabervon.org>,
       Gene Heskett <gene.heskett@gmail.com>, Zan Lynx <zlynx@acm.org>,
       Calvin Walton <calvin.walton@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux ide Mailing list <linux-ide@vger.kernel.org>
Subject: Re: Problem with ata layer in 2.6.24
References: <200801272122.21823.gene.heskett@gmail.com>	<1201539043.31293.7.camel@zem>	<1201540830.6526.19.camel@localhost>	<200801281230.32910.gene.heskett@gmail.com>	<alpine.LNX.1.00.0801281248190.13593@iabervon.org>	<479E1D9E.3000900@bobjweil.com> <20080129121201.2f727f5f@core>
In-Reply-To: <20080129121201.2f727f5f@core>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> not one problem but lots---is sufficiently widespread that a Mini HOWTO, 
>> say, would be really welcome and, I'm guessing, widely used.
>>     
>
> We don't see very many libata problems at the distro level and they for
> the most part boil down to
>
> - sata_nv with >4GB of RAM, knowing being worked on, no old IDE driver
> anyway
>   
Is this >4GB or >=4GB? I've seen contradictory reports, and I've got 4GB.

Richard

