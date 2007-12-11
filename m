Return-Path: <linux-kernel-owner+w=401wt.eu-S1756453AbXLKXxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453AbXLKXxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 18:53:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbXLKXww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 18:52:52 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:35884 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbXLKXwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 18:52:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=pvdZz2uzNWPsbEUcYuP178NpRHeh94IIqyXFyHnl0CsenG2xvbjGM1fFHy4FddkH98GcUldGmLXCXH8TyekVpn38rW9qwgzPOOyKaX7I6INm2txK2vjmla1m+lI/QCBv3a5wBFprSax1t5hCs4r8WSul6+LfQn1IGUnzDumI3X8=
Message-ID: <475F227D.7050203@keyaccess.nl>
Date: Wed, 12 Dec 2007 00:51:25 +0100
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Alejandro_Riveira_Fern=E1ndez?= 
	<ariveira@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, dpreed@reed.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, pavel@ucw.cz, andi@firstfloor.org,
       rol@as2917.net, Krzysztof Halasa <khc@pm.waw.pl>, david@davidnewall.com,
       hpa@zytor.com, john@stoffel.org, linux-os@analogic.com
Subject: Re: [RFT] Port 0x80 I/O speed
References: <475F1DC6.5090403@keyaccess.nl> <20071212004316.079e3a05@Varda>
In-Reply-To: <20071212004316.079e3a05@Varda>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
From: Rene Herman <rene.herman@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-12-07 00:43, Alejandro Riveira Fernández wrote:

>  On my AMD 3800 X2 (2000MHz) ULi M1697 2.6.24-rc5 i get:
> 
>  cycles: out 1844674407370808, in 1844674407369087
>  
> It is not constant but variations are not significant afaics

Eh, oh, I guess you need to compile as a 32-bit binary...

Rene.
