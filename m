Return-Path: <linux-kernel-owner+w=401wt.eu-S1754080AbYEDPHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbYEDPHN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 11:07:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750847AbYEDPHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 11:07:00 -0400
Received: from hs-out-0708.google.com ([64.233.178.242]:54052 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbYEDPG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 11:06:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding:sender;
        b=AmHNUx/gJcV3lgsXA6ks/5VRTYGJ6bUWQc8Z8UYNyG/o6wqMUm6RbJl36AoMYgMjj8Al4eiK3xG+l0nLV8w9PRiL8dn0t+tBFrFdeowHEW3kRWwrvgUM7/DOQddlYLYoYIdaKUnBkA18Qp1wDp5B9S8+fMI6jbVY4olNhMn5NcI=
Subject: Re: i387/FPU init issues...
From: jamal <hadi@cyberus.ca>
Reply-To: hadi@cyberus.ca
To: Sebastian Herbszt <herbszt@gmx.de>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, jbeulich@novell.com
In-Reply-To: <004701c8ade8$266832c0$0201a8c0@zeug>
References: <1209810775.6972.37.camel@localhost>
	 <alpine.LFD.1.10.0805031650120.6003@apollo.tec.linutronix.de>
	 <481CA40A.7040906@zytor.com>
	 <Pine.LNX.4.55.0805032016560.20206@cliff.in.clinika.pl>
	 <481CC5CD.8060205@zytor.com>
	 <Pine.LNX.4.55.0805032209480.20206@c <1209851170.6972.64.camel@localhost>
	 <004701c8ade8$266832c0$0201a8c0@zeug>
Content-Type: text/plain
Date: Sun, 04 May 2008 11:06:52 -0400
Message-Id: <1209913612.6972.89.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-04-05 at 15:08 +0200, Sebastian Herbszt wrote:


> this is the same result i get with qemu 0.8.2. 

Thanks for validating. 
I am embarassed to say I am still running version 0.7.0 - problem is i
have patched it semi-substantially to add features which i didnt get
much luck in pushing in; so i cant upgrade overnight.

> With version 0.9.0 and
> later it is:

Ok, maybe it is time to invest time to forward port my patches. I dont
see anything in the release notes between 0.8.2 and 0.9.0 which says
this problem was known and fixed in some specific version. Any pointers?

Thanks again - you saved me a lot of time.

cheers,
jamal

